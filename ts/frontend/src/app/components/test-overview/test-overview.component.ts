import { Component, inject, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core'
import { BenchmarkDefinitionRow, BenchmarkGroupDefinitionRow, TestDefinitionRow } from '@common/interfaces'
import { getPrimaryScoring } from '@common/scoring-utils'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { TableColumn, TableComponent, TableRow } from '../table/table.component'

@Component({
  selector: 'app-test-overview',
  imports: [TableComponent],
  templateUrl: './test-overview.component.html',
  styleUrl: './test-overview.component.scss',
})
export class TestOverviewComponent implements OnInit, OnChanges {
  @Input() group?: BenchmarkGroupDefinitionRow
  @Input() benchmark?: BenchmarkDefinitionRow
  @Input() test?: TestDefinitionRow

  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)

  customization?: Customization

  columns: TableColumn[] = [{ title: 'Rank' }, { title: 'Submission' }, { title: 'Score', align: 'right' }]
  rows: TableRow[] = []

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['group'] || changes['benchmark'] || changes['test']) {
      this.buildBoard()
    }
  }

  async buildBoard() {
    if (this.group && this.benchmark && this.test) {
      const group = this.group
      const benchmark = this.benchmark
      const test = this.test
      const testOverview = (
        await this.resourceService.load('/results/benchmarks/:benchmark_id/tests/:test_ids', {
          params: { benchmark_id: benchmark.id, test_ids: test.id },
        })
      )?.at(0)
      const fields = await this.resourceService.loadGrouped('/definitions/fields/:field_ids', {
        params: { field_ids: test.field_ids },
      })
      // pre-fetch linked resources
      await Promise.all([
        this.resourceService.loadGrouped('/submissions/:submission_ids', {
          params: { submission_ids: testOverview?.items.map((item) => item.submission_id) ?? [] },
        }),
      ])
      this.rows = await Promise.all(
        testOverview?.items.map(async (item) => {
          const submission = (
            await this.resourceService.load('/submissions/:submission_ids', {
              params: { submission_ids: item.submission_id },
            })
          )?.at(0)
          // only consider scorings for this test
          const scorings = item.test_scorings.find((testScorings) => testScorings.test_id === test.id)!.scorings
          const primary = getPrimaryScoring(scorings, fields)
          return {
            routerLink: ['/', 'benchmarks', group.id, benchmark.id, 'submissions', item.submission_id],
            cells: [
              { text: primary?.rank ?? '-' },
              { text: submission?.name ?? 'NA' },
              { scorings: scorings, fieldDefinitions: fields },
            ],
          }
        }) ?? [],
      )
    } else {
      this.rows = []
    }
  }
}
