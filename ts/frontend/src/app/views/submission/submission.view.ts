import { CommonModule } from '@angular/common'
import { Component, OnDestroy, OnInit, inject } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute } from '@angular/router'
import {
  BenchmarkDefinitionRow,
  SubmissionRow,
  SubmissionScore,
  SuiteDefinitionRow,
  TestDefinitionRow,
} from '@common/interfaces'
import { isScored } from '@common/scoring-utils'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { Subscription } from 'rxjs'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { SubmissionResultsComponent } from '../../components/submission-results/submission-results.component'
import { ApiService } from '../../features/api/api.service'
import { AuthService } from '../../features/auth/auth.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-submission',
  imports: [
    CommonModule,
    FormsModule,
    ContentComponent,
    SiteHeadingComponent,
    PublicResourcePipe,
    SubmissionResultsComponent,
  ],
  templateUrl: './submission.view.html',
  styleUrl: './submission.view.scss',
})
export class SubmissionView implements OnInit, OnDestroy {
  private apiService = inject(ApiService)
  private authService = inject(AuthService)
  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)
  private route = inject(ActivatedRoute)
  private paramsSubscription?: Subscription

  suite?: SuiteDefinitionRow
  benchmark?: BenchmarkDefinitionRow
  test?: TestDefinitionRow
  submission?: SubmissionRow
  submissionScore?: SubmissionScore
  ownSubmission = false
  customization?: Customization

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
    this.paramsSubscription = this.route.params.subscribe(({ suite_id, benchmark_id, submission_id }) => {
      this.resourceService
        .load('/definitions/suites/:suite_ids', { params: { suite_ids: suite_id } })
        .then((suites) => {
          this.suite = suites?.at(0)
        })
      this.resourceService
        .load('/definitions/benchmarks/:benchmark_ids', { params: { benchmark_ids: benchmark_id } })
        .then((benchmark) => {
          this.benchmark = benchmark?.at(0)
        })
      this.resourceService
        .load('/submissions/:submission_ids', { params: { submission_ids: submission_id } })
        .then((submissions) => {
          this.submission = submissions?.at(0)
          this.ownSubmission = this.submission?.submitted_by === this.authService.userUuid
        })
      this.resourceService
        .load('/results/submissions/:submission_ids', { params: { submission_ids: submission_id } })
        .then((scores) => {
          this.submissionScore = scores?.at(0)
        })
    })
  }

  ngOnDestroy(): void {
    this.paramsSubscription?.unsubscribe()
  }

  isSubmissionScored() {
    return isScored(this.submissionScore)
  }

  canPublishSubmission() {
    return this.isSubmissionScored() && this.submission?.published === false && this.ownSubmission
  }

  async publish() {
    this.submission = (
      await this.apiService.patch('/submissions/:submission_ids', { params: { submission_ids: this.submission!.id } })
    ).body?.at(0)
  }
}
