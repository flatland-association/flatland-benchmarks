import { Component, inject, OnDestroy, OnInit } from '@angular/core'
import { ActivatedRoute, RouterModule } from '@angular/router'
import { BenchmarkDefinitionRow, SuiteDefinitionRow, TestDefinitionRow } from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { Subscription } from 'rxjs'
import { SiteHeadingComponent } from '../../components/site-heading/site-heading.component'
import { TestOverviewComponent } from '../../components/test-overview/test-overview.component'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'view-test',
  imports: [
    ContentComponent,
    RouterModule,
    SiteHeadingComponent,
    SectionComponent,
    PublicResourcePipe,
    TestOverviewComponent,
  ],
  templateUrl: './test.view.html',
  styleUrl: './test.view.scss',
})
export class TestView implements OnInit, OnDestroy {
  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)
  private route = inject(ActivatedRoute)
  private paramsSubscription?: Subscription

  suite?: SuiteDefinitionRow
  benchmark?: BenchmarkDefinitionRow
  test?: TestDefinitionRow
  customization?: Customization

  ngOnInit(): void {
    this.customizationService.getCustomization().then((customization) => {
      this.customization = customization
    })
    this.paramsSubscription = this.route.params.subscribe(({ suite_id, benchmark_id, test_id }) => {
      this.resourceService
        .load('/definitions/suites/:suite_ids', { params: { suite_ids: suite_id } })
        .then((suites) => {
          this.suite = suites?.at(0)
        })
      this.resourceService
        .load('/definitions/benchmarks/:benchmark_ids', { params: { benchmark_ids: benchmark_id } })
        .then((benchmark) => {
          this.benchmark = benchmark?.at(0)
        })
      this.resourceService.load('/definitions/tests/:test_ids', { params: { test_ids: test_id } }).then((test) => {
        this.test = test?.at(0)
      })
    })
  }

  ngOnDestroy(): void {
    this.paramsSubscription?.unsubscribe()
  }
}
