import { Component, inject, Input, OnChanges, SimpleChanges } from '@angular/core'
import { BenchmarkGroupDefinitionRow } from '@common/interfaces'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { ApiService } from '../../features/api/api.service'
import { CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { TableColumn, TableComponent, TableRow } from '../table/table.component'

@Component({
  selector: 'app-benchmark-overview',
  imports: [ContentComponent, TableComponent],
  templateUrl: './benchmark-overview.component.html',
  styleUrl: './benchmark-overview.component.scss',
})
export class BenchmarkOverviewComponent implements OnChanges {
  @Input() group?: BenchmarkGroupDefinitionRow

  resourceService = inject(ResourceService)
  apiService = inject(ApiService)
  customizationService = inject(CustomizationService)

  columns: TableColumn[] = [
    { title: 'Benchmark' },
    { title: 'Submissions', align: 'right' },
    { title: 'Best Score', align: 'right' },
  ]
  rows: TableRow[] = []

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['group']) {
      this.buildBoard()
    }
  }

  async buildBoard() {
    if (this.group) {
      this.rows = await Promise.all(
        this.group.benchmark_ids?.map(async (benchmarkId) => {
          const benchmark = await this.resourceService.load('/definitions/benchmarks/', benchmarkId)
          const fields = await this.resourceService.loadMultiOrdered('/definitions/fields/', benchmark.field_ids)
          // TODO: load via resource service as well
          // see: https://github.com/flatland-association/flatland-benchmarks/issues/395
          const leaderboard = (
            await this.apiService.get('/results/benchmarks/:benchmark_ids', {
              params: { benchmark_ids: benchmarkId },
            })
          ).body?.at(0)
          return {
            // TODO: route to generalized page
            // see: https://github.com/flatland-association/flatland-benchmarks/issues/323
            routerLink: ['/', 'fab-benchmarks', benchmarkId],
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
