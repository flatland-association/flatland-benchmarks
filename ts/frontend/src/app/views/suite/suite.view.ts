import { Component, inject, OnDestroy, OnInit } from '@angular/core'
import { ActivatedRoute } from '@angular/router'
import { BenchmarkDefinitionRow, SuiteDefinitionRow } from '@common/interfaces'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { Subscription } from 'rxjs'
import { BenchmarkOverviewComponent } from '../../components/benchmark-overview/benchmark-overview.component'
import { CampaignOverviewComponent } from '../../components/campaign-overview/campaign-overview.component'
import { NewSubmissionModalComponent } from '../../components/new-submission-modal/new-submission-modal.component'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { SuiteOverviewComponent } from '../../components/suite-overview/suite-overview.component'
import { TabsComponent } from '../../components/tabs/tabs.component'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-suite',
  imports: [
    ContentComponent,
    SiteHeadingComponent,
    PublicResourcePipe,
    CampaignOverviewComponent,
    SuiteOverviewComponent,
    TabsComponent,
    BenchmarkOverviewComponent,
    NewSubmissionModalComponent,
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
  firstBenchmark?: BenchmarkDefinitionRow
  showNewSubmissionModal = false

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
    this.paramsSubscription = this.route.params.subscribe(({ suite_id }) => {
      this.resourceService
        .load('/definitions/suites/:suite_ids', { params: { suite_ids: suite_id } })
        .then((suites) => {
          this.suite = suites?.at(0)
          const benchmark_id = this.suite?.benchmark_ids.at(0)
          if (benchmark_id) {
            this.resourceService
              .load('/definitions/benchmarks/:benchmark_ids', {
                params: { benchmark_ids: [benchmark_id] },
              })
              .then((benchmark) => {
                this.firstBenchmark = benchmark?.at(0)
              })
          }
        })
    })
  }

  ngOnDestroy(): void {
    this.paramsSubscription?.unsubscribe()
  }
}
