import { DecimalPipe } from '@angular/common'
import { Component, inject, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core'
import { BenchmarkDefinitionRow, SubmissionRow, SuiteDefinitionRow } from '@common/interfaces'
import { isScored } from '@common/scoring-utils'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { TableColumn, TableComponent, TableRow } from '../table/table.component'

@Component({
  selector: 'app-submission-results',
  imports: [TableComponent],
  providers: [DecimalPipe],
  templateUrl: './submission-results.component.html',
  styleUrl: './submission-results.component.scss',
})
export class SubmissionResultsComponent implements OnInit, OnChanges {
  @Input() suite?: SuiteDefinitionRow
  @Input() benchmark?: BenchmarkDefinitionRow
  @Input() submission?: SubmissionRow

  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)
  private decimalPipe = inject(DecimalPipe)

  customization?: Customization

  totalScore = '-'
  columns: TableColumn[] = [{ title: 'Test / Scenario' }, { title: 'Score', align: 'right' }]
  rows: TableRow[] = []

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['benchmark'] || changes['submission']) {
      this.buildBoard()
    }
  }

  async buildBoard() {
    if (this.suite && this.benchmark && this.submission) {
      const suite = this.suite
      const benchmark = this.benchmark
      const submission = this.submission
      const submissionScore = (
        await this.resourceService.load('/results/submissions/:submission_ids', {
          params: { submission_ids: submission.id },
        })
      )?.at(0)
      this.totalScore = '-'
      if (isScored(submissionScore)) {
        if (submissionScore?.scorings) {
          const primaryScoring = submissionScore.scorings[0]
          if (primaryScoring) {
            this.totalScore = this.decimalPipe.transform(primaryScoring.score, '1.2-2') ?? '-'
          }
        }
      } else {
        this.totalScore = '⚠️'
      }
      this.rows = []
      // build in temporary table first i.o.t. reduce flicker
      const rows: TableRow[] = []
      for (const testScore of submissionScore?.test_scorings ?? []) {
        // append one line per test
        const test = (
          await this.resourceService.load('/definitions/tests/:test_ids', {
            params: { test_ids: testScore.test_id },
          })
        )?.at(0)
        const testFields = await this.resourceService.loadOrdered('/definitions/fields/:field_ids', {
          params: { field_ids: test?.field_ids ?? [] },
        })
        const isTestScored = isScored(testScore)
        rows.push({
          cells: [
            { text: test?.name ?? 'NA' },
            isTestScored ? { scorings: testScore.scorings, fieldDefinitions: testFields } : { text: '⚠️' },
          ],
        })
        //... and one line per scenario directly under the test line
        for (const scenarioScore of testScore.scenario_scorings) {
          const scenario = (
            await this.resourceService.load('/definitions/scenarios/:scenario_ids', {
              params: { scenario_ids: scenarioScore.scenario_id },
            })
          )?.at(0)
          const scenarioFields = await this.resourceService.loadOrdered('/definitions/fields/:field_ids', {
            params: { field_ids: scenario?.field_ids ?? [] },
          })
          const isScenarioScored = isScored(scenarioScore)
          rows.push({
            routerLink: [
              '/',
              'suites',
              suite.id,
              benchmark.id,
              'submissions',
              submission.id,
              test?.id ?? '',
              scenario?.id ?? '',
            ],
            cells: [
              { text: ' • ' + (scenario?.name ?? 'NA') },
              isScenarioScored
                ? { scorings: scenarioScore.scorings, fieldDefinitions: scenarioFields }
                : { text: '⚠️' },
            ],
          })
        }
      }
      this.rows = rows
    } else {
      this.rows = []
    }
  }
}
