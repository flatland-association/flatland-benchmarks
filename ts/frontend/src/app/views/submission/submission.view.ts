import { CommonModule } from '@angular/common'
import { Component, OnInit } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute } from '@angular/router'
import { Result, SubmissionPreview } from '@common/interfaces.mjs'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { LeaderboardComponent } from '../../components/leaderboard/leaderboard.component'
import { ApiService } from '../../features/api/api.service'

const CHECK_RESULT_INTERVAL = 10000 // [ms]

@Component({
  selector: 'view-submission',
  imports: [CommonModule, FormsModule, ContentComponent, LeaderboardComponent],
  templateUrl: './submission.view.html',
  styleUrl: './submission.view.scss',
})
export class SubmissionView implements OnInit {
  submissionUuid?: string

  mySubmission?: SubmissionPreview

  // start with an empty result (user feedback, something is going)
  result?: Result = {
    dir: '/results/',
    id: 0,
    submission: 0,
    done_at: null,
    success: null,
    scores: null,
    results_str: null,
    public: null,
  }
  acceptEula = false

  constructor(
    route: ActivatedRoute,
    public apiService: ApiService,
  ) {
    this.submissionUuid = route.snapshot.params['submission']
  }

  ngOnInit() {
    const interval = window.setInterval(() => {
      this.apiService.get('/submissions/:uuid/results', { params: { uuid: `${this.submissionUuid}` } }).then((res) => {
        if (res.body) {
          this.result = res.body[0]
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
            window.clearInterval(interval)
          }
        }
      })
    }, CHECK_RESULT_INTERVAL)
  }

  async publishResult() {
    if (this.result) {
      this.result.public = true
      this.result = (await this.apiService.patch('/result', { body: this.result })).body
    }
  }
}
