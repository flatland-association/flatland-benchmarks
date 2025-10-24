import { DatePipe } from '@angular/common'
import { Component, inject, OnInit } from '@angular/core'
import { RouterModule } from '@angular/router'
import { isSubmissionCompletelyScored } from '@common/scoring-utils'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { TableColumn, TableComponent, TableRow } from '../../components/table/table.component'
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
    this.resourceService
      .load('/submissions', { query: { submitted_by: this.authService.userUuid, unpublished_own: 'true' } })
      .then(async (submissions) => {
        if (!submissions?.length) {
          this.rows = []
          return
        }
        const scores = await this.resourceService.loadGrouped('/results/submissions/:submission_ids', {
          params: { submission_ids: submissions.map((s) => s.id) },
        })
        const benchmarks = await this.resourceService.loadGrouped('/definitions/benchmarks/:benchmark_ids', {
          params: { benchmark_ids: submissions?.map((s) => s.benchmark_id) ?? [] },
        })
        const suites = await this.resourceService.loadGrouped('/definitions/suites/:suite_ids', {
          params: { suite_ids: benchmarks?.filter((b) => !!b.suite_id).map((b) => b.suite_id!) ?? [] },
        })
        await this.resourceService.load('/definitions/fields/:field_ids', {
          params: { field_ids: benchmarks?.flatMap((b) => b.field_ids) ?? [] },
        })
        this.rows = await Promise.all(
          submissions?.map(async (submission) => {
            const score = scores?.find((s) => s?.submission_id === submission.id)
            const benchmark = benchmarks?.find((b) => b.id === submission.benchmark_id)
            const suite = suites?.find((s) => s.id === benchmark?.suite_id)
            const fields = await this.resourceService.load('/definitions/fields/:field_ids', {
              params: { field_ids: benchmark?.field_ids ?? [] },
            })
            const startedAtStr = submission.submitted_at
              ? this.datePipe.transform(submission.submitted_at, 'dd/MM/yyyy HH:mm')
              : ''
            const isScored = isSubmissionCompletelyScored(score)
            return {
              routerLink:
                suite && benchmark ? ['/', 'suites', suite.id, benchmark.id, 'submissions', submission.id] : undefined,
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
