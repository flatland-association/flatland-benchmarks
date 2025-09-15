import { Component, OnDestroy, OnInit, inject } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute, Router } from '@angular/router'
import { BenchmarkDefinitionRow, BenchmarkGroupDefinitionRow, TestDefinitionRow } from '@common/interfaces'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { Subscription } from 'rxjs'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { ApiService } from '../../features/api/api.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-new-submission',
  imports: [FormsModule, ContentComponent, SiteHeadingComponent, PublicResourcePipe],
  templateUrl: './new-submission.view.html',
  styleUrl: './new-submission.view.scss',
})
export class NewSubmissionView implements OnInit, OnDestroy {
  private apiService = inject(ApiService)
  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)
  private router = inject(Router)
  private route = inject(ActivatedRoute)
  private paramsSubscription?: Subscription

  group?: BenchmarkGroupDefinitionRow
  benchmark?: BenchmarkDefinitionRow
  tests?: TestDefinitionRow[]
  customization?: Customization

  submissionName = ''
  submissionDataUrl = ''
  codeRepositoryUrl = ''
  testsSelection: boolean[] = []

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
    this.paramsSubscription = this.route.params.subscribe(({ group_id, benchmark_id, test_id }) => {
      this.resourceService
        .load('/definitions/benchmark-groups/:group_ids', { params: { group_ids: group_id } })
        .then((group) => {
          this.group = group?.at(0)
        })
      // In campaign setting, test_id will be passed and only that test needs
      // to be loaded. In other settings, all tests need to be loaded.
      this.resourceService
        .load('/definitions/benchmarks/:benchmark_ids', { params: { benchmark_ids: benchmark_id } })
        .then((benchmark) => {
          this.benchmark = benchmark?.at(0)
          if (!test_id) {
            this.resourceService
              .load('/definitions/tests/:test_ids', { params: { test_ids: this.benchmark?.test_ids ?? [] } })
              .then((tests) => {
                this.tests = tests
                this.testsSelection = Array(this.tests?.length).fill(true)
              })
          }
        })
      if (test_id) {
        this.resourceService.load('/definitions/tests/:test_ids', { params: { test_ids: test_id } }).then((tests) => {
          this.tests = tests
        })
      }
    })
  }

  ngOnDestroy(): void {
    this.paramsSubscription?.unsubscribe()
  }

  requiresSubmissionDataUrl() {
    if (this.group?.setup === 'CAMPAIGN') {
      // data url only required if not OFFLINE
      return this.tests?.at(0)?.loop !== 'OFFLINE'
    } else {
      // data url is always required in other setups
      return true
    }
  }

  requiresCodeRepository() {
    // code repository is not required in campaign setup
    return this.group?.setup !== 'CAMPAIGN'
  }

  requiresTestSelection() {
    // tests selection can only be made manually in benchmark setup
    return this.group?.setup === 'DEFAULT'
  }

  canSubmit() {
    if (!this.group || !this.benchmark || !this.tests) return false
    if (!this.submissionName) return false
    if (this.requiresSubmissionDataUrl()) {
      // url must only be non-blank - validity check is left for orchestrator
      if (!this.submissionDataUrl) return false
    }
    if (this.requiresCodeRepository()) {
      if (!this.isValidUrl(this.codeRepositoryUrl)) return false
    }
    if (this.requiresTestSelection()) {
      if (this.testsSelection.reduce((p, c) => p + +c, 0) === 0) return false
    }
    return true
  }

  isValidUrl(str: string) {
    try {
      const url = new URL(str)
      return url.protocol === 'http:' || url.protocol === 'https:'
      // eslint-disable-next-line unused-imports/no-unused-vars
    } catch (_error) {
      return false
    }
  }

  async submit() {
    let test_ids: string[] = []
    if (this.group?.setup === 'CAMPAIGN') {
      test_ids = [this.tests![0].id]
    } else if (this.group?.setup === 'DEFAULT') {
      test_ids = this.tests!.filter((t, i) => this.testsSelection[i]).map((t) => t.id)
    } else {
      test_ids = this.tests!.map((t) => t.id)
    }
    const response = await this.apiService.post('/submissions', {
      body: {
        name: this.submissionName,
        benchmark_id: this.benchmark?.id ?? '',
        submission_data_url: this.submissionDataUrl,
        code_repository: this.codeRepositoryUrl,
        test_ids,
      },
    })
    if (response.body?.id) {
      // navigate to that submissions' detail view
      this.router.navigateByUrl(`benchmarks/${this.group!.id}/${this.benchmark!.id}/submissions/${response.body.id}`)
    }
  }
}
