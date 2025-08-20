import { Component, inject, OnInit } from '@angular/core'
import { ActivatedRoute, RouterModule } from '@angular/router'
import {
  FieldDefinitionRow,
  ScenarioDefinitionRow,
  SubmissionRow,
  SubmissionScore,
  TestDefinitionRow,
} from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { TableColumn, TableComponent, TableRow } from '../../components/table/table.component'
import { ApiService } from '../../features/api/api.service'
import { AuthService } from '../../features/auth/auth.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

/**
 * Returns whether all submission's scenarios have non-null scores only.
 */
export function isLeaderboardItemScored(item: SubmissionScore) {
  const scenarioScorings = item.test_scorings.flatMap((test) =>
    test.scenario_scorings.map((scenario) => scenario.scorings),
  )
  return scenarioScorings.every((scoring) => {
    const keys = Object.keys(scoring)
    return keys.every((key) => scoring[key]?.score !== null)
  })
}

@Component({
  selector: 'view-vc-submission',
  imports: [
    RouterModule,
    ContentComponent,
    SectionComponent,
    BreadcrumbsComponent,
    PublicResourcePipe,
    SiteHeadingComponent,
    TableComponent,
  ],
  templateUrl: './vc-submission.view.html',
  styleUrl: './vc-submission.view.scss',
})
export class VcSubmissionView implements OnInit {
  apiService = inject(ApiService)
  authService = inject(AuthService)
  customizationService = inject(CustomizationService)

  submissionId: string
  submission?: SubmissionRow
  submissionBoard?: SubmissionScore
  tests?: Map<string, TestDefinitionRow>
  scenarios?: Map<string, ScenarioDefinitionRow>
  fields?: Map<string, FieldDefinitionRow>
  customization?: Customization

  ownSubmission = false

  columns: TableColumn[] = [{ title: 'Test' }, { title: 'Scenario' }, { title: 'Score', align: 'right' }]
  rows: TableRow[] = []

  constructor() {
    const route = inject(ActivatedRoute)

    this.submissionId = route.snapshot.params['submission_id']
  }

  async ngOnInit() {
    this.customization = await this.customizationService.getCustomization()
    this.submission = (
      await this.apiService.get('/submissions/:submission_ids', { params: { submission_ids: this.submissionId } })
    ).body?.at(0)
    this.ownSubmission = this.submission?.submitted_by === this.authService.userUuid
    this.submissionBoard = (
      await this.apiService.get('/results/submissions/:submission_ids', {
        params: { submission_ids: this.submissionId },
      })
    ).body?.at(0)
    // load linked resources
    // TODO: offload this to service with caching
    // build array of unique test ids
    const testIds = Array.from(new Set(this.submissionBoard?.test_scorings.map((test) => test.test_id)))
    if (testIds) {
      const tests = (
        await this.apiService.get('/definitions/tests/:test_ids', { params: { test_ids: testIds.join(',') } })
      ).body
      this.tests = new Map(tests?.map((test) => [test.id, test]))
    }
    // build array of unique scenario ids
    const scenarioIds = Array.from(
      new Set(
        this.submissionBoard?.test_scorings.flatMap((test) =>
          test.scenario_scorings.map((scenario) => scenario.scenario_id),
        ),
      ),
    )
    if (scenarioIds) {
      const scenarios = (
        await this.apiService.get('/definitions/scenarios/:scenario_ids', {
          params: { scenario_ids: scenarioIds.join(',') },
        })
      ).body
      this.scenarios = new Map(scenarios?.map((scenario) => [scenario.id, scenario]))
    }
    // build array of unique field ids from all tests and scenarios
    const fieldIdsSet = new Set<string>()
    this.tests?.forEach((test) => {
      test.field_ids.forEach((fieldId) => {
        fieldIdsSet.add(fieldId)
      })
    })
    this.scenarios?.forEach((scenario) => {
      scenario.field_ids.forEach((fieldId) => {
        fieldIdsSet.add(fieldId)
      })
    })
    const fieldIds = Array.from(fieldIdsSet)
    if (fieldIds) {
      const fields = (
        await this.apiService.get('/definitions/fields/:field_ids', {
          params: { field_ids: fieldIds.join(',') },
        })
      ).body
      this.fields = new Map(fields?.map((field) => [field.id, field]))
    }
    // build table rows from board
    this.rows = []
    // append one line per test
    this.submissionBoard?.test_scorings.forEach((testScore) => {
      const test = this.tests?.get(testScore.test_id)
      const fields = test?.field_ids.map((fieldId) => this.fields?.get(fieldId))
      this.rows.push({
        cells: [{ text: test?.name ?? 'NA' }, { text: '' }, { scorings: testScore.scorings, fieldDefinitions: fields }],
      })
      //... and per scenario
      testScore.scenario_scorings.forEach((scenarioScore) => {
        const scenario = this.scenarios?.get(scenarioScore.scenario_id)
        const fields = scenario?.field_ids.map((fieldId) => this.fields?.get(fieldId))
        this.rows.push({
          routerLink: ['results', testScore.test_id, scenarioScore.scenario_id],
          cells: [
            { text: '' },
            { text: scenario?.name ?? 'NA' },
            { scorings: scenarioScore.scorings, fieldDefinitions: fields },
          ],
        })
      })
    })
  }

  isSubmissionScored() {
    return this.submissionBoard ? isLeaderboardItemScored(this.submissionBoard) : false
  }

  async publish() {
    if (this.submission && this.ownSubmission && this.isSubmissionScored()) {
      this.submission = (
        await this.apiService.patch('/submissions/:submission_ids', { params: { submission_ids: this.submission.id } })
      ).body?.at(0)
    }
  }
}
