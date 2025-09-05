import { Component, inject, OnInit } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ActivatedRoute, RouterModule } from '@angular/router'
import {
  BenchmarkDefinitionRow,
  CampaignItemOverview,
  FieldDefinitionRow,
  SubmissionRow,
  TestDefinitionRow,
} from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { BreadcrumbsComponent } from '../../components/breadcrumbs/breadcrumbs.component'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { TableColumn, TableComponent, TableRow } from '../../components/table/table.component'
import { ApiService } from '../../features/api/api.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-vc-evaluation-objective',
  imports: [
    FormsModule,
    RouterModule,
    ContentComponent,
    SectionComponent,
    BreadcrumbsComponent,
    PublicResourcePipe,
    SiteHeadingComponent,
    TableComponent,
  ],
  templateUrl: './vc-evaluation-objective.view.html',
  styleUrl: './vc-evaluation-objective.view.scss',
})
export class VcEvaluationObjectiveView implements OnInit {
  apiService = inject(ApiService)
  customizationService = inject(CustomizationService)

  benchmarkId: string
  benchmark?: BenchmarkDefinitionRow
  tests?: Map<string, TestDefinitionRow>
  fields?: Map<string, FieldDefinitionRow>
  submissions?: Map<string, SubmissionRow>
  campaignItemOverview?: CampaignItemOverview
  customization?: Customization

  columns: TableColumn[] = [{ title: 'KPI' }, { title: 'Score', align: 'right' }]
  rows: TableRow[] = []

  constructor() {
    const route = inject(ActivatedRoute)

    this.benchmarkId = route.snapshot.params['benchmark_id']
  }

  async ngOnInit() {
    this.customization = await this.customizationService.getCustomization()
    this.benchmark = (
      await this.apiService.get('/definitions/benchmarks/:benchmark_ids', {
        params: { benchmark_ids: this.benchmarkId },
      })
    ).body?.at(0)
    this.campaignItemOverview = (
      await this.apiService.get('/results/campaign-items/:benchmark_ids', {
        params: { benchmark_ids: this.benchmarkId },
      })
    ).body?.at(0)
    // load linked resources
    // TODO: offload this to service with caching
    const testIds = this.campaignItemOverview?.items.map((item) => item.test_id).join(',')
    if (testIds) {
      this.tests = new Map(
        (
          await this.apiService.get('/definitions/tests/:test_ids', {
            params: { test_ids: testIds },
          })
        ).body?.map((test) => [test.id, test]),
      )
    }
    const subIds = this.campaignItemOverview?.items
      .map((item) => item.submission_id)
      .filter((id) => !!id)
      .join(',')
    if (subIds) {
      this.submissions = new Map(
        (
          await this.apiService.get('/submissions/:submission_ids', {
            params: { submission_ids: subIds },
          })
        ).body?.map((submission) => [submission.id, submission]),
      )
    }
    // build array of unique field ids from all tests
    const fieldIdsSet = new Set<string>()
    this.tests?.forEach((test) => {
      test.field_ids.forEach((fieldId) => {
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
    this.rows =
      this.campaignItemOverview?.items.map((item) => {
        const test = this.tests?.get(item.test_id)
        const fields = test?.field_ids.map((fieldId) => this.fields?.get(fieldId))
        return {
          routerLink: ['tests', item.test_id],
          cells: [{ text: test?.name ?? 'NA' }, { scorings: item.scorings, fieldDefinitions: fields }],
        }
      }) ?? []
  }
}
