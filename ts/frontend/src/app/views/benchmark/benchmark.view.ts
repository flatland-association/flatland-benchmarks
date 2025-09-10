import { Component, inject, OnDestroy, OnInit } from '@angular/core'
import { ActivatedRoute, RouterModule } from '@angular/router'
import { BenchmarkDefinitionRow, BenchmarkGroupDefinitionRow } from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { Subscription } from 'rxjs'
import { BenchmarkOverviewComponent } from '../../components/benchmark-overview/benchmark-overview.component'
import { CampaignItemOverviewComponent } from '../../components/campaign-item-overview/campaign-item-overview.component'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-benchmark',
  imports: [
    RouterModule,
    ContentComponent,
    SiteHeadingComponent,
    SectionComponent,
    PublicResourcePipe,
    CampaignItemOverviewComponent,
    BenchmarkOverviewComponent,
  ],
  templateUrl: './benchmark.view.html',
  styleUrl: './benchmark.view.scss',
})
export class BenchmarkView implements OnInit, OnDestroy {
  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)
  private route = inject(ActivatedRoute)
  private paramsSubscription?: Subscription

  group?: BenchmarkGroupDefinitionRow
  benchmark?: BenchmarkDefinitionRow
  customization?: Customization

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
    this.paramsSubscription = this.route.params.subscribe(({ group_id, benchmark_id }) => {
      this.resourceService
        .load('/definitions/benchmark-groups/:group_ids', { params: { group_ids: group_id } })
        .then((group) => {
          this.group = group?.at(0)
        })
      this.resourceService
        .load('/definitions/benchmarks/:benchmark_ids', { params: { benchmark_ids: benchmark_id } })
        .then((benchmark) => {
          this.benchmark = benchmark?.at(0)
        })
    })
  }

  ngOnDestroy(): void {
    this.paramsSubscription?.unsubscribe()
  }
}
