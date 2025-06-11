import { CommonModule } from '@angular/common'
import { Component, OnDestroy, OnInit, inject } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute } from '@angular/router'
import { LeaderboardItem, Scorings, SubmissionRow } from '@common/interfaces'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { ApiService } from '../../features/api/api.service'

const CHECK_RESULT_INTERVAL = 10000 // [ms]

@Component({
  selector: 'view-submission',
  imports: [CommonModule, FormsModule, ContentComponent, BreadcrumbsComponent],
  templateUrl: './submission.view.html',
  styleUrl: './submission.view.scss',
})
export class SubmissionView implements OnInit, OnDestroy {
  apiService = inject(ApiService)

  submissionUuid?: string

  submission?: SubmissionRow

  result?: LeaderboardItem

  isLive = false
  timeout?: number

  constructor() {
    const route = inject(ActivatedRoute)

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
    if (!this.result && this.isLive) {
      this.timeout = window.setTimeout(() => {
        this.watchResult()
      }, CHECK_RESULT_INTERVAL)
    }
  }

  async loadResult() {
    if (this.submissionUuid) {
      await this.apiService
        .get('/results/submission/:submission_id', { params: { submission_id: this.submissionUuid } })
        .then((res) => {
          this.result = res.body?.at(0)
          console.log(this.result)
        })
    }
  }

  async publishResult() {
    // if (this.result) {
    //   this.result.public = true
    //   // strip result_str to circumvent "payload too large" error
    //   this.result.results_str = null
    //   this.result = (await this.apiService.patch('/result', { body: this.result })).body
    // }
  }

  getPrimaryScoring(scorings: Scorings) {
    const key = Object.keys(scorings)[0]
    return scorings[key]
  }

  getSecondaryScorings(scorings: Scorings) {
    const keys = Object.keys(scorings).slice(1)
    return keys.map((key) => scorings[key])
  }

  getScoringKeys(scorings: unknown) {
    return Object.keys(scorings as object)
  }
}
