import { Component, OnInit } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute } from '@angular/router'
import { consolidateResourceLocator, endpointFromResourceLocator } from '@common/endpoint-utils.mjs'
import { Benchmark, Result, Submission, Test } from '@common/interfaces.mjs'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-benchmarks-detail',
  imports: [FormsModule, ContentComponent],
  templateUrl: './benchmarks-detail.view.html',
  styleUrl: './benchmarks-detail.view.scss',
})
export class BenchmarksDetailView implements OnInit {
  id: string
  benchmark?: Benchmark
  submissions?: Submission[]
  tests?: Test[]
  result?: Result

  submissionImageUrl = ''
  codeRepositoryUrl = ''
  testsSelection: boolean[] = []

  constructor(
    route: ActivatedRoute,
    public apiService: ApiService,
  ) {
    this.id = route.snapshot.params['id']
  }

  async ngOnInit() {
    this.benchmark = (await this.apiService.get('/benchmarks/:id', { params: { id: this.id } })).body?.at(0)
    const locators = (await this.apiService.get('/submissions', { query: { benchmark: this.benchmark?.id } })).body
    if (locators && locators.length > 0) {
      const combined = consolidateResourceLocator(locators)
      this.submissions = (await this.apiService.get<Submission[]>(...endpointFromResourceLocator(combined))).body
    }
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

  async submit() {
    const response = await this.apiService.post('/submissions', {
      body: {
        benchmark: this.benchmark?.id ?? 0,
        submission_image: this.submissionImageUrl,
        code_repository: this.codeRepositoryUrl,
        tests: this.tests?.filter((t, i) => this.testsSelection[i]).map((t) => t.id) ?? [],
      },
    })
    if (response.body?.id) {
      // start with an empty result (user feedback, something is going)
      this.result = {
        dir: '/results/',
        id: 0,
        submission: response.body.id,
        done_at: null,
        success: null,
        scores: null,
        results_str: null,
      }
      const id = response.body.id
      const interval = window.setInterval(() => {
        this.apiService.get('/submissions/:id/results', { params: { id: `${id}` } }).then((res) => {
          if (res.body) {
            this.result = res.body[0]
            // clear interval once the result indicates success
            if (this.result.success) {
              window.clearInterval(interval)
            }
          }
        })
      }, 10000)
    }
  }
}
