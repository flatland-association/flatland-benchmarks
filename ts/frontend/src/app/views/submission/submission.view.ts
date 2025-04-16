import { CommonModule } from '@angular/common'
import { Component, OnDestroy, OnInit } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute } from '@angular/router'
import { Result, Submission, SubmissionPreview } from '@common/interfaces'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { LeaderboardComponent } from '../../components/leaderboard/leaderboard.component'
import { ApiService } from '../../features/api/api.service'

const CHECK_RESULT_INTERVAL = 10000 // [ms]

// fab-3-specific?
interface ResultObject {
  status: string
  result: {
    exc_type?: string
    exc_message?: string[]
    exc_module?: string
    'f3-evaluator'?: {
      job_status?: string
      'results.csv'?: string
      'results.json'?: string
    }
    'f3-submission'?: {
      job_status?: string
      image_id?: string
    }
  }
}

interface F3EvaluatorResult {
  state?: string
  progress?: number
  simulation_count?: number
  total_simulation_count?: number
  score?: Record<string, number>
  meta?: {
    normalized_reward?: number
    termination_cause?: string
    private_metadata_s3_key?: string
    reward?: number
    percentage_complete?: number
  }
}

@Component({
  selector: 'view-submission',
  imports: [CommonModule, FormsModule, ContentComponent, BreadcrumbsComponent, LeaderboardComponent],
  templateUrl: './submission.view.html',
  styleUrl: './submission.view.scss',
})
export class SubmissionView implements OnInit, OnDestroy {
  submissionUuid?: string

  submission?: Submission
  mySubmission?: SubmissionPreview

  result?: Result
  resultObj?: ResultObject
  resultsJson?: F3EvaluatorResult
  resultsCsv?: string
  testScores?: { test: string; score: number }[]
  acceptEula = false

  isLive = false
  timeout?: number

  constructor(
    route: ActivatedRoute,
    public apiService: ApiService,
  ) {
    this.submissionUuid = route.snapshot.params['submission']
  }

  ngOnInit() {
    // load submission details
    if (this.submissionUuid) {
      this.apiService.get('/submissions/:uuid', { params: { uuid: this.submissionUuid } }).then(({ body }) => {
        this.submission = body?.at(0)
      })
    }
    // try loading result directly
    this.isLive = true
    this.watchResult()
  }

  ngOnDestroy() {
    this.isLive = false
    if (this.timeout) {
      window.clearTimeout(this.timeout)
    }
  }

  // tries to load the result and if its not available schedules a reload
  // (can't work with window.setInterval as the request might take longer than the interval)
  async watchResult() {
    // try loading result
    await this.loadResult()
    // schedule next load if
    // - result is not available
    // - component is still live (could have been destroyed during load)
    if ((!this.result || !this.result.success) && this.isLive) {
      this.timeout = window.setTimeout(() => {
        this.watchResult()
      }, CHECK_RESULT_INTERVAL)
    }
  }

  async loadResult() {
    await this.apiService
      .get('/submissions/:uuid/results', { params: { uuid: `${this.submissionUuid}` } })
      .then(async (res) => {
        if (res.body) {
          this.result = res.body[0]
          if (this.result.results_str) {
            this.resultObj = JSON.parse(this.result.results_str)
            this.resultsJson = JSON.parse(this.resultObj?.result['f3-evaluator']?.['results.json'] ?? 'null')
            this.resultsCsv = this.resultObj?.result['f3-evaluator']?.['results.csv']
            // primitively parse CSV and accumulate single test scores
            // ⚠ hard-coded last-second "solution" ⚠
            const lines = this.resultsCsv?.split('\n').slice(1, -1)
            this.testScores = []
            lines?.forEach((line) => {
              const cells = line.split(',')
              const test = cells[1] // manually counted
              const score = cells[17] // guessed there's no time to count
              let testScore = this.testScores!.at(-1)
              if (!testScore || testScore.test !== test) {
                testScore = { test, score: 0 }
                this.testScores!.push(testScore)
              }
              testScore.score += +score
            })
          }
          // once result indicates success
          if (this.result.success) {
            //... load submissions preview from backend so it's complete
            await this.apiService
              .get('/submissions', {
                query: {
                  uuid: this.submissionUuid,
                },
              })
              .then((r) => {
                this.mySubmission = r.body?.at(0)
              })
          }
        }
      })
  }

  async publishResult() {
    if (this.result) {
      this.result.public = true
      // strip result_str to circumvent "payload too large" error
      this.result.results_str = null
      this.result = (await this.apiService.patch('/result', { body: this.result })).body
    }
  }
}
