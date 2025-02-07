import { CommonModule } from '@angular/common'
import { Component, OnDestroy, OnInit } from '@angular/core'
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
export class SubmissionView implements OnInit, OnDestroy {
  submissionUuid?: string

  mySubmission?: SubmissionPreview

  result?: Result
  acceptEula = false

  interval?: number

  constructor(
    route: ActivatedRoute,
    public apiService: ApiService,
  ) {
    this.submissionUuid = route.snapshot.params['submission']
  }

  ngOnInit() {
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
      this.result = (await this.apiService.patch('/result', { body: this.result })).body
    }
  }
}
