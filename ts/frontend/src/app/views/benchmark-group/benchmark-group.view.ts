import { Component, inject, OnDestroy, OnInit } from '@angular/core'
import { ActivatedRoute } from '@angular/router'
import { BenchmarkGroupDefinitionRow } from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { Subscription } from 'rxjs'
import { BenchmarkGroupOverviewComponent } from '../../components/benchmark-group-overview/benchmark-group-overview.component'
import { CampaignOverviewComponent } from '../../components/campaign-overview/campaign-overview.component'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-benchmark-group',
  imports: [
    ContentComponent,
    SiteHeadingComponent,
    PublicResourcePipe,
    SectionComponent,
    CampaignOverviewComponent,
    BenchmarkGroupOverviewComponent,
  ],
  templateUrl: './benchmark-group.view.html',
  styleUrl: './benchmark-group.view.scss',
})
export class BenchmarkGroupView implements OnInit, OnDestroy {
  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)
  private route = inject(ActivatedRoute)
  private paramsSubscription?: Subscription

  group?: BenchmarkGroupDefinitionRow
  customization?: Customization

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
    this.paramsSubscription = this.route.params.subscribe(({ group_id }) => {
      this.resourceService
        .load('/definitions/benchmark-groups/:group_ids', { params: { group_ids: group_id } })
        .then((group) => {
          this.group = group?.at(0)
        })
    })
  }

  ngOnDestroy(): void {
    this.paramsSubscription?.unsubscribe()
  }
}
