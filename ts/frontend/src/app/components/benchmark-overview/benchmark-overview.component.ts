import { Component, inject, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core'
import { BenchmarkDefinitionRow, BenchmarkGroupDefinitionRow } from '@common/interfaces'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { TableColumn, TableComponent, TableRow } from '../table/table.component'

@Component({
  selector: 'app-benchmark-overview',
  imports: [ContentComponent, TableComponent],
  templateUrl: './benchmark-overview.component.html',
  styleUrl: './benchmark-overview.component.scss',
})
export class BenchmarkOverviewComponent implements OnInit, OnChanges {
  @Input() group?: BenchmarkGroupDefinitionRow
  @Input() benchmark?: BenchmarkDefinitionRow

  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)

  customization?: Customization

  columns: TableColumn[] = [{ title: 'Submission' }, { title: 'Score', align: 'right' }]
  rows: TableRow[] = []

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['group'] || changes['benchmark']) {
      this.buildBoard()
    }
  }

  async buildBoard() {
    if (this.group && this.benchmark) {
      const group = this.group
      const benchmark = this.benchmark
      const benchmarkOverview = (
        await this.resourceService.load('/results/benchmarks/:benchmark_ids', {
          params: { benchmark_ids: this.benchmark.id },
        })
      )?.at(0)
      const fields = await this.resourceService.loadGrouped('/definitions/fields/:field_ids', {
        params: { field_ids: this.benchmark.field_ids },
      })
      // pre-fetch linked resources
      await Promise.all([
        this.resourceService.loadGrouped('/submissions/:submission_ids', {
          params: { submission_ids: benchmarkOverview?.items.map((item) => item.submission_id) ?? [] },
        }),
        this.resourceService
          .loadGrouped('/definitions/tests/:test_ids', {
            params: { test_ids: this.benchmark.test_ids ?? [] },
          })
          .then((tests) =>
            this.resourceService.loadGrouped('/definitions/fields/:field_ids', {
              params: { field_ids: tests?.flatMap((test) => test.field_ids) ?? [] },
            }),
          ),
      ])
      this.rows = await Promise.all(
        benchmarkOverview?.items.map(async (item) => {
          const submission = (
            await this.resourceService.load('/submissions/:submission_ids', {
              params: { submission_ids: item.submission_id },
            })
          )?.at(0)
          return {
            routerLink: ['/', 'benchmarks', group.id, benchmark.id, 'submissions', item.submission_id],
            cells: [{ text: submission?.name ?? 'NA' }, { scorings: item.scorings, fieldDefinitions: fields }],
          }
        }) ?? [],
      )
    } else {
      this.rows = []
    }
  }
}
