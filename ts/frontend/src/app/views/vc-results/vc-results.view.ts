import { Component, inject, OnInit } from '@angular/core'
import { ActivatedRoute, RouterModule } from '@angular/router'
import {
  FieldDefinitionRow,
  PostTestResultsBody,
  ScenarioDefinitionRow,
  Scoring,
  SubmissionRow,
  SubmissionScenarioScore,
} from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { TableColumn, TableComponent, TableRow } from '../../components/table/table.component'
import { ApiService } from '../../features/api/api.service'
import { AuthService } from '../../features/auth/auth.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-vc-results',
  imports: [
    RouterModule,
    ContentComponent,
    SectionComponent,
    BreadcrumbsComponent,
    PublicResourcePipe,
    SiteHeadingComponent,
    TableComponent,
  ],
  templateUrl: './vc-results.view.html',
  styleUrl: './vc-results.view.scss',
})
export class VcResultsView implements OnInit {
  apiService = inject(ApiService)
  authService = inject(AuthService)
  customizationService = inject(CustomizationService)

  submissionId: string
  testId: string
  scenarioId: string
  submission?: SubmissionRow
  scenario?: ScenarioDefinitionRow
  results?: SubmissionScenarioScore
  fields?: FieldDefinitionRow[]
  manualFields: string[] = []
  customization?: Customization

  ownSubmission = false

  columns: TableColumn[] = [{ title: 'Field' }, { title: 'Description' }, { title: 'Score', align: 'right' }]
  rows: TableRow[] = []

  constructor() {
    const route = inject(ActivatedRoute)

    this.submissionId = route.snapshot.params['submission_id']
    this.testId = route.snapshot.params['test_id']
    this.scenarioId = route.snapshot.params['scenario_id']
  }

  async ngOnInit() {
    this.customization = await this.customizationService.getCustomization()
    this.submission = (
      await this.apiService.get('/submissions/:submission_ids', { params: { submission_ids: this.submissionId } })
    ).body?.at(0)
    this.ownSubmission = this.submission?.submitted_by === this.authService.userUuid
    this.scenario = (
      await this.apiService.get('/definitions/scenarios/:scenario_ids', { params: { scenario_ids: this.scenarioId } })
    ).body?.at(0)
    this.results = (
      await this.apiService.get('/results/submissions/:submission_id/scenario/:scenario_ids', {
        params: { submission_id: this.submissionId, scenario_ids: this.scenarioId },
      })
    ).body?.at(0)
    // load linked resources
    // TODO: offload this to service with caching
    const fieldIds = this.scenario?.field_ids
    if (fieldIds) {
      this.fields = (
        await this.apiService.get('/definitions/fields/:field_ids', { params: { field_ids: fieldIds.join(',') } })
      ).body
    }
    this.rebuildView()
  }

  rebuildView() {
    // find out which fields need manual scoring
    this.fields?.forEach((field) => {
      const isScored = typeof this.results?.scorings[field.key]?.score === 'number'
      if (!isScored) {
        this.manualFields.push(field.key)
      }
    })
    // build table
    this.rows =
      this.fields?.map((field) => {
        // take existing scoring or prepare one for manual submission
        const scoring: Scoring = this.results?.scorings[field.key] ?? { score: null }
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
    return this.manualFields.every((key) => typeof this.results?.scorings[key]?.score === 'number')
  }

  async submitManualScoring() {
    // prepare body data object
    //@ts-expect-error type
    const results: PostTestResultsBody['data'][0] = {
      scenario_id: this.scenarioId,
    }
    // append manual scores
    this.manualFields.forEach((key) => {
      results[key] = this.results?.scorings[key]?.score ?? 0
    })
    // submit
    await this.apiService.post('/results/submissions/:submission_id/tests/:test_ids', {
      params: { submission_id: this.submissionId, test_ids: this.testId },
      body: { data: [results] },
    })
    // rebuild view with local data
    this.rebuildView()
  }
}
