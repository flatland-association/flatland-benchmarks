import { DecimalPipe } from '@angular/common'
import { Component, inject, OnDestroy, OnInit } from '@angular/core'
import { ActivatedRoute } from '@angular/router'
import {
  FieldDefinitionRow,
  PostTestResultsBody,
  ScenarioDefinitionRow,
  Scoring,
  SubmissionRow,
  SubmissionScenarioScore,
  SubmissionScore,
  TestDefinitionRow,
} from '@common/interfaces'
import { getPrimaryScoring, isScenarioCompletelyScored } from '@common/scoring-utils'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { Subscription } from 'rxjs'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { TableColumn, TableComponent, TableRow } from '../../components/table/table.component'
import { ApiService } from '../../features/api/api.service'
import { AuthService } from '../../features/auth/auth.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-submission-scenario-results',
  imports: [ContentComponent, SiteHeadingComponent, PublicResourcePipe, TableComponent],
  providers: [DecimalPipe],
  templateUrl: './submission-scenario-results.view.html',
  styleUrl: './submission-scenario-results.view.scss',
})
export class SubmissionScenarioResultsView implements OnInit, OnDestroy {
  private authService = inject(AuthService)
  private apiService = inject(ApiService)
  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)
  private decimalPipe = inject(DecimalPipe)
  private route = inject(ActivatedRoute)
  private paramsSubscription?: Subscription

  test?: TestDefinitionRow
  scenario?: ScenarioDefinitionRow
  fields?: FieldDefinitionRow[]
  manualFields: string[] = []
  scenarioScore?: SubmissionScenarioScore
  submission?: SubmissionRow
  submissionScore?: SubmissionScore
  ownSubmission = false
  customization?: Customization

  totalScore = '-'
  columns: TableColumn[] = [{ title: 'Field' }, { title: 'Description' }, { title: 'Score', align: 'right' }]
  rows: TableRow[] = []

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
    this.paramsSubscription = this.route.params.subscribe(({ test_id, submission_id, scenario_id }) => {
      Promise.all([
        this.resourceService.load('/definitions/tests/:test_ids', { params: { test_ids: test_id } }).then((tests) => {
          this.test = tests?.at(0)
        }),
        this.resourceService
          .load('/definitions/scenarios/:scenario_ids', { params: { scenario_ids: scenario_id } })
          .then((scenarios) => {
            this.scenario = scenarios?.at(0)
            return this.resourceService
              .loadGrouped('/definitions/fields/:field_ids', {
                params: { field_ids: this.scenario?.field_ids ?? [] },
              })
              .then((fields) => {
                this.fields = fields
              })
          }),
        this.resourceService
          .load('/submissions/:submission_ids', { params: { submission_ids: submission_id } })
          .then((submissions) => {
            this.submission = submissions?.at(0)
            this.ownSubmission = this.submission?.submitted_by === this.authService.userUuid
          }),
        this.resourceService
          .load('/results/submissions/:submission_id/scenario/:scenario_ids', {
            params: { submission_id: submission_id, scenario_ids: scenario_id },
          })
          .then((scores) => {
            this.scenarioScore = scores?.at(0)
          }),
      ]).then(() => {
        this.buildBoard()
      })
    })
  }

  ngOnDestroy(): void {
    this.paramsSubscription?.unsubscribe()
  }

  isScenarioScored() {
    return this.manualFields.length === 0 && isScenarioCompletelyScored(this.scenarioScore)
  }

  async buildBoard() {
    this.totalScore = '-'
    if (isScenarioCompletelyScored(this.scenarioScore)) {
      if (this.scenarioScore?.scorings) {
        const primaryScoring = getPrimaryScoring(this.scenarioScore?.scorings, this.fields)
        if (primaryScoring) {
          this.totalScore = this.decimalPipe.transform(primaryScoring.score, '1.2-2') ?? '-'
        }
      }
    } else {
      this.totalScore = '⚠️'
    }
    // find out which fields need manual scoring (not having numerical score)
    this.manualFields = []
    this.fields?.forEach((field) => {
      const isScored = typeof this.scenarioScore?.scorings[field.key]?.score === 'number'
      if (!isScored) {
        this.manualFields.push(field.key)
      }
    })
    // build table
    this.rows =
      this.fields?.map((field) => {
        // take existing scoring or prepare one for manual submission
        const scoring: Scoring = this.scenarioScore?.scorings[field.key] ?? { score: null }
        const isScored = typeof scoring.score === 'number'
        return {
          cells: [
            { text: field.key },
            { text: field.description },
            isScored
              ? // when scored, show score as text (not formatted as scoring)
                { text: scoring.score ?? null }
              : //... otherwise, depending on submission owner
                this.ownSubmission
                ? // own submission: show input
                  {
                    input: {
                      value: scoring.score,
                      onChange: (value: number) => {
                        scoring.score = value
                      },
                    },
                  }
                : // indicate unavailable score
                  {
                    text: 'NA',
                  },
          ],
        }
      }) ?? []
  }

  needsManualScoring() {
    return this.manualFields.length > 0
  }

  canSubmitManualScoring() {
    return this.manualFields.every((key) => typeof this.scenarioScore?.scorings[key]?.score === 'number')
  }

  async submitManualScoring() {
    // prepare body data object
    const results: PostTestResultsBody = {
      data: [
        {
          scenario_id: this.scenario!.id,
          scores: {},
        },
      ],
    }
    // append manual scores
    this.manualFields.forEach((key) => {
      results.data[0].scores[key] = this.scenarioScore?.scorings[key]?.score ?? 0
    })
    // submit
    this.apiService
      .post('/results/submissions/:submission_id/tests/:test_ids', {
        params: { submission_id: this.submission!.id, test_ids: this.test!.id },
        body: results,
      })
      .then(() => {
        // reload results from backend
        return this.resourceService
          .load('/results/submissions/:submission_id/scenario/:scenario_ids', {
            params: { submission_id: this.submission!.id, scenario_ids: this.scenario!.id },
          })
          .then((scores) => {
            this.scenarioScore = scores?.at(0)
            this.buildBoard()
          })
      })
  }
}
