import { CommonModule } from '@angular/common'
import { Component, OnDestroy, OnInit } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute } from '@angular/router'
import { Result, Submission, SubmissionPreview } from '@common/interfaces.mjs'
import { ContentComponent } from '@flatland-association/flatland-ui'
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
  imports: [CommonModule, FormsModule, ContentComponent, LeaderboardComponent],
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
  acceptEula = false

  interval?: number

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
    this.loadResult()
    // and after that, auto-refresh until results are here (check done in loadResult())
    this.interval = window.setInterval(() => {
      this.loadResult()
    }, CHECK_RESULT_INTERVAL)
  }

  ngOnDestroy() {
    if (this.interval) {
      window.clearInterval(this.interval)
    }
  }

  async loadResult() {
    this.apiService.get('/submissions/:uuid/results', { params: { uuid: `${this.submissionUuid}` } }).then((res) => {
      if (res.body) {
        this.result = res.body[0]
        if (this.result.results_str) {
          this.resultObj = JSON.parse(this.result.results_str)
          this.resultsJson = JSON.parse(this.resultObj?.result['f3-evaluator']?.['results.json'] ?? 'null')
        }
        // once result indicates success
        if (this.result.success) {
          //... load submissions preview from backend so it's complete
          this.apiService
            .get('/submissions', {
              query: {
                uuid: this.submissionUuid,
              },
            })
            .then((r) => {
              this.mySubmission = r.body?.at(0)
            })
          //... and clear interval
          if (this.interval) {
            window.clearInterval(this.interval)
          }
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
