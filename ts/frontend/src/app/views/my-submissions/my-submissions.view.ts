import { DatePipe } from '@angular/common'
import { Component, inject, OnInit } from '@angular/core'
import { RouterModule } from '@angular/router'
import { isSubmissionCompletelyScored } from '@common/scoring-utils'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { TableColumn, TableComponent, TableRow } from '../../components/table/table.component'
import { ApiService } from '../../features/api/api.service'
import { AuthService } from '../../features/auth/auth.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-my-submissions',
  imports: [RouterModule, ContentComponent, PublicResourcePipe, SiteHeadingComponent, TableComponent],
  providers: [DatePipe],
  templateUrl: './my-submissions.view.html',
  styleUrl: './my-submissions.view.scss',
})
export class MySubmissionsView implements OnInit {
  private authService = inject(AuthService)
  private apiService = inject(ApiService)
  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)
  private datePipe = inject(DatePipe)

  customization?: Customization

  columns: TableColumn[] = [
    { title: 'Submission' },
    { title: 'Submitted for' },
    { title: 'Started' },
    { title: 'Score', align: 'right' },
  ]
  rows: TableRow[] = []

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
    // TODO: load via resource service
    // see: https://github.com/flatland-association/flatland-benchmarks/issues/395
    this.apiService
      .get('/submissions', { query: { submitted_by: this.authService.userUuid } })
      .then(async (resonse) => {
        const submissions = resonse.body
        if (!submissions) {
          this.rows = []
          return
        }
        // TODO: load via resource service
        // see: https://github.com/flatland-association/flatland-benchmarks/issues/395
        const scores = (
          await this.apiService.get('/results/submissions/:submission_ids', {
            params: { submission_ids: submissions.map((s) => s.id).join(',') },
          })
        ).body
        // TODO: load only linked suites
        // see: https://github.com/flatland-association/flatland-benchmarks/issues/410
        // TODO: load via resource service
        // see: https://github.com/flatland-association/flatland-benchmarks/issues/395
        const suites = (await this.apiService.get('/definitions/suites'))?.body
        const benchmarks = await this.resourceService.loadGrouped('/definitions/benchmarks/:benchmark_ids', {
          params: { benchmark_ids: submissions?.map((s) => s.benchmark_id) ?? [] },
        })
        await this.resourceService.load('/definitions/fields/:field_ids', {
          params: { field_ids: benchmarks?.flatMap((b) => b.field_ids) ?? [] },
        })
        this.rows = await Promise.all(
          submissions?.map(async (submission) => {
            const score = scores?.find((s) => s?.submission_id === submission.id)
            const benchmark = benchmarks?.find((b) => b.id === submission.benchmark_id)
            const suite = benchmark?.id ? suites?.find((s) => s.benchmark_ids.includes(benchmark.id)) : undefined
            const fields = await this.resourceService.load('/definitions/fields/:field_ids', {
              params: { field_ids: benchmark?.field_ids ?? [] },
            })
            const startedAtStr = submission.submitted_at
              ? this.datePipe.transform(submission.submitted_at, 'dd/MM/yyyy HH:mm')
              : ''
            const isScored = isSubmissionCompletelyScored(score)
            return {
              routerLink:
                suite && benchmark
                  ? ['/', 'benchmarks', suite.id, benchmark.id, 'submissions', submission.id]
                  : undefined,
              cells: [
                { text: submission.name },
                { text: `${suite?.name ?? 'NA'} / ${benchmark?.name ?? 'NA'}` },
                { text: startedAtStr },
                isScored ? { scorings: score!.scorings, fieldDefinitions: fields } : { text: '⚠️' },
              ],
            }
          }) ?? [],
        )
      })
  }
}
