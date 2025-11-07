import { Component, effect, inject, Input, model, OnChanges, OnInit, SimpleChanges } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { Router } from '@angular/router'
import { BenchmarkDefinitionRow, SuiteDefinitionRow, TestDefinitionRow } from '@common/interfaces'
import { ContentComponent, ModalComponent } from '@flatland-association/flatland-ui'
import { ApiService } from '../../features/api/api.service'
import { AuthService } from '../../features/auth/auth.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'
import { SiteHeadingComponent } from '../site-heading/site-heading.component'

@Component({
  selector: 'app-new-submission-modal',
  imports: [FormsModule, ModalComponent, ContentComponent, SiteHeadingComponent, PublicResourcePipe],
  templateUrl: './new-submission-modal.component.html',
  styleUrl: './new-submission-modal.component.scss',
})
export class NewSubmissionModalComponent implements OnInit, OnChanges {
  private authService = inject(AuthService)
  private apiService = inject(ApiService)
  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)
  private router = inject(Router)

  @Input() suiteId?: string
  @Input() benchmarkId?: string
  @Input() testId?: string

  suite?: SuiteDefinitionRow
  benchmark?: BenchmarkDefinitionRow
  tests?: TestDefinitionRow[]
  customization?: Customization

  open = model<boolean>(true)
  showForm = false

  submissionName = ''
  submissionDataUrl = ''
  codeRepositoryUrl = ''
  testsSelection: boolean[] = []

  constructor() {
    effect(async () => {
      if (this.open()) {
        if (!this.authService.isLoggedIn()) {
          await this.authService.logIn()
        }
        this.showForm = true
      } else {
        this.showForm = false
      }
    })
  }

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['suiteId'] && this.suiteId) {
      this.resourceService
        .load('/definitions/suites/:suite_ids', { params: { suite_ids: this.suiteId } })
        .then((suites) => {
          this.suite = suites?.at(0)
        })
    }
    if (changes['benchmarkId'] && this.benchmarkId) {
      // In campaign setting, test_id will be passed and only that test needs
      // to be loaded. In other settings, all tests need to be loaded.
      this.resourceService
        .load('/definitions/benchmarks/:benchmark_ids', { params: { benchmark_ids: this.benchmarkId } })
        .then((benchmark) => {
          this.benchmark = benchmark?.at(0)
          // If no testId was passed (i.e. not in CAMPAIGN setup), load all test
          // definitions from benchmark.
          if (!this.testId) {
            this.resourceService
              .load('/definitions/tests/:test_ids', { params: { test_ids: this.benchmark?.test_ids ?? [] } })
              .then((tests) => {
                this.tests = tests
                this.testsSelection = Array(this.tests?.length).fill(true)
              })
          }
        })
    }
    if (changes['testId'] && this.testId) {
      this.resourceService.load('/definitions/tests/:test_ids', { params: { test_ids: this.testId } }).then((tests) => {
        this.tests = tests
      })
    }
  }

  requiresSubmissionDataUrl() {
    if (this.suite?.setup === 'CAMPAIGN') {
      // data url only required if not OFFLINE
      return this.tests?.at(0)?.loop !== 'OFFLINE'
    } else {
      // data url is always required in other setups
      return true
    }
  }

  requiresCodeRepository() {
    // code repository is not required in campaign setup
    return this.suite?.setup !== 'CAMPAIGN'
  }

  requiresTestSelection() {
    // tests selection can only be made manually in benchmark setup
    return this.suite?.setup === 'DEFAULT'
  }

  canSubmit() {
    if (!this.suite || !this.benchmark || !this.tests) return false
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
    if (this.suite?.setup === 'CAMPAIGN') {
      test_ids = [this.tests![0].id]
    } else if (this.suite?.setup === 'DEFAULT') {
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
      this.router.navigateByUrl(`suites/${this.suite!.id}/${this.benchmark!.id}/submissions/${response.body.id}`)
    }
  }
}
