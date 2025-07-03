import { Component, OnInit, inject } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute, Router } from '@angular/router'
import { BenchmarkDefinitionRow, TestDefinitionRow } from '@common/interfaces'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-new-submission',
  imports: [FormsModule, ContentComponent, BreadcrumbsComponent],
  templateUrl: './new-submission.view.html',
  styleUrl: './new-submission.view.scss',
})
export class NewSubmissionView implements OnInit {
  apiService = inject(ApiService)
  private router = inject(Router)

  id: string
  benchmark?: BenchmarkDefinitionRow
  tests?: TestDefinitionRow[]

  submissionImageUrl = ''
  codeRepositoryUrl = ''
  submissionName = ''
  testsSelection: boolean[] = []

  constructor() {
    const route = inject(ActivatedRoute)

    this.id = route.snapshot.params['id']
  }

  async ngOnInit() {
    this.benchmark = (await this.apiService.get('/definitions/benchmarks/:ids', { params: { ids: this.id } })).body?.at(
      0,
    )
    console.log(this.benchmark)
    // load all the available tests
    this.tests = (
      await this.apiService.get('/definitions/tests/:ids', {
        params: {
          ids: this.benchmark!.test_ids.join(','),
        },
      })
    ).body
    this.testsSelection = Array(this.tests?.length).fill(true)
  }

  canSubmit() {
    return (
      this.submissionName != '' &&
      this.submissionImageUrl != '' &&
      this.codeRepositoryUrl != '' &&
      !this.submissionImageUrl.includes(' ') &&
      this.testsSelection.reduce((p, c) => p + +c, 0)
    )
  }

  async submit() {
    const response = await this.apiService.post('/submissions', {
      body: {
        name: this.submissionName,
        benchmark_id: this.benchmark?.id ?? '',
        submission_data_url: this.submissionImageUrl,
        code_repository: this.codeRepositoryUrl,
        test_ids: this.tests?.filter((t, i) => this.testsSelection[i]).map((t) => t.id) ?? [],
      },
    })
    if (response.body?.id) {
      // navigate to that submissions' detail view
      this.router.navigateByUrl(`benchmarks/${this.benchmark?.id ?? 0}/participate/submissions/${response.body.id}`)
    }
  }
}
