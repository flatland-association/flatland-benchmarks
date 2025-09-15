import { Component, inject, OnDestroy, OnInit } from '@angular/core'
import { ActivatedRoute } from '@angular/router'
import { SuiteDefinitionRow } from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { Subscription } from 'rxjs'
import { CampaignOverviewComponent } from '../../components/campaign-overview/campaign-overview.component'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { SuiteOverviewComponent } from '../../components/suite-overview/suite-overview.component'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-suite',
  imports: [
    ContentComponent,
    SiteHeadingComponent,
    PublicResourcePipe,
    SectionComponent,
    CampaignOverviewComponent,
    SuiteOverviewComponent,
  ],
  templateUrl: './suite.view.html',
  styleUrl: './suite.view.scss',
})
export class SuiteView implements OnInit, OnDestroy {
  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)
  private route = inject(ActivatedRoute)
  private paramsSubscription?: Subscription

  suite?: SuiteDefinitionRow
  customization?: Customization

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
    this.paramsSubscription = this.route.params.subscribe(({ suite_id }) => {
      this.resourceService
        .load('/definitions/suites/:suite_ids', { params: { suite_ids: suite_id } })
        .then((suites) => {
          this.suite = suites?.at(0)
        })
    })
  }

  ngOnDestroy(): void {
    this.paramsSubscription?.unsubscribe()
  }
}
