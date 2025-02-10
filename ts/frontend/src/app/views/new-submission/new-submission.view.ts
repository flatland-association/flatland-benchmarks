import { CommonModule } from '@angular/common'
import { Component, OnInit } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute, Router } from '@angular/router'
import { Benchmark, Test } from '@common/interfaces.mjs'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-new-submission',
  imports: [CommonModule, FormsModule, ContentComponent, BreadcrumbsComponent],
  templateUrl: './new-submission.view.html',
  styleUrl: './new-submission.view.scss',
})
export class NewSubmissionView implements OnInit {
  id: string
  benchmark?: Benchmark
  tests?: Test[]

  submissionImageUrl = ''
  codeRepositoryUrl = ''
  submissionName = ''
  testsSelection: boolean[] = []

  constructor(
    route: ActivatedRoute,
    public apiService: ApiService,
    private router: Router,
  ) {
    this.id = route.snapshot.params['id']
  }

  async ngOnInit() {
    this.benchmark = (await this.apiService.get('/benchmarks/:id', { params: { id: this.id } })).body?.at(0)
    // load all the available tests
    this.tests = (
      await this.apiService.get('/tests/:id', {
        params: {
          id: this.benchmark!.tests.join(','),
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
        benchmark: this.benchmark?.id ?? 0,
        submission_image: this.submissionImageUrl,
        code_repository: this.codeRepositoryUrl,
        tests: this.tests?.filter((t, i) => this.testsSelection[i]).map((t) => t.id) ?? [],
      },
    })
    if (response.body?.uuid) {
      // navigate to that submissions' detail view
      this.router.navigateByUrl(`benchmarks/${this.benchmark?.id ?? 0}/participate/submissions/${response.body.uuid}`)
    }
  }
}
