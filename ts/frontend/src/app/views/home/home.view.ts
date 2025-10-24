import { Component, OnInit, inject } from '@angular/core'
import { SuiteDefinitionRow } from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { SuiteCardComponent } from '../../components/suite-card/suite-card.component'
import { Customization, CustomizationService } from '../../features/customization/customization.service'
import { ResourceService } from '../../features/resource/resource.service'

@Component({
  selector: 'view-home',
  imports: [ContentComponent, SectionComponent, SuiteCardComponent],
  templateUrl: './home.view.html',
  styleUrl: './home.view.scss',
})
export class HomeView implements OnInit {
  private resourceService = inject(ResourceService)
  private customizationService = inject(CustomizationService)

  suites?: SuiteDefinitionRow[]
  customization?: Customization
  leadHtml?: string

  async ngOnInit() {
    this.customization = await this.customizationService.getCustomization()
    this.suites = await this.resourceService.load('/definitions/suites')
    this.leadHtml = this.customization.content.home.lead
  }
}
