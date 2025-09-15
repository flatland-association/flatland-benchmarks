import { Component, inject, Input, OnChanges, SimpleChanges } from '@angular/core'
import { SuiteDefinitionRow } from '@common/interfaces'
import { ResourceService } from '../../features/resource/resource.service'
import { TableColumn, TableComponent, TableRow } from '../table/table.component'

@Component({
  selector: 'app-suite-overview',
  imports: [TableComponent],
  templateUrl: './suite-overview.component.html',
  styleUrl: './suite-overview.component.scss',
})
export class SuiteOverviewComponent implements OnChanges {
  @Input() suite?: SuiteDefinitionRow
  @Input() benchmarksTitle?: string

  private resourceService = inject(ResourceService)

  columns: TableColumn[] = [
    { title: 'Benchmark' },
    { title: 'Submissions', align: 'right' },
    { title: 'Best Score', align: 'right' },
  ]
  rows: TableRow[] = []

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['suite']) {
      this.buildBoard()
    }
    if (changes['benchmarksTitle']) {
      this.columns[0].title = this.benchmarksTitle ?? 'Benchmark'
    }
  }

  async buildBoard() {
    if (this.suite) {
      const suite = this.suite
      // pre-fetch linked resources
      Promise.all([
        this.resourceService
          .loadGrouped('/definitions/benchmarks/:benchmark_ids', {
            params: { benchmark_ids: this.suite.benchmark_ids ?? [] },
          })
          .then((benchmarks) =>
            this.resourceService.loadGrouped('/definitions/fields/:field_ids', {
              params: { field_ids: benchmarks?.flatMap((benchmark) => benchmark.field_ids) ?? [] },
            }),
          ),
      ])
      this.rows = await Promise.all(
        this.suite.benchmark_ids?.map(async (benchmarkId) => {
          const benchmark = (
            await this.resourceService.load('/definitions/benchmarks/:benchmark_ids', {
              params: { benchmark_ids: benchmarkId },
            })
          )?.at(0)
          const fields = await this.resourceService.loadGrouped('/definitions/fields/:field_ids', {
            params: { field_ids: benchmark?.field_ids ?? [] },
          })
          const leaderboard = (
            await this.resourceService.load('/results/benchmarks/:benchmark_ids', {
              params: { benchmark_ids: benchmarkId },
            })
          )?.at(0)
          return {
            routerLink: ['/', 'benchmarks', suite.id, benchmarkId],
            cells: [
              { text: benchmark?.name ?? 'NA' },
              { text: leaderboard?.items.length ?? 0 },
              { scorings: leaderboard?.items.at(0)?.scorings ?? null, fieldDefinitions: fields },
            ],
          }
        }) ?? [],
      )
    } else {
      this.rows = []
    }
  }
}
