import { Component, OnInit, inject } from '@angular/core'
import { SuiteDefinitionRow } from '@common/interfaces'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { SuiteCardComponent } from '../../components/suite-card/suite-card.component'
import { ApiService } from '../../features/api/api.service'
import { Customization, CustomizationService } from '../../features/customization/customization.service'

@Component({
  selector: 'view-home',
  imports: [ContentComponent, SectionComponent, SuiteCardComponent],
  templateUrl: './home.view.html',
  styleUrl: './home.view.scss',
})
export class HomeView implements OnInit {
  apiService = inject(ApiService)
  customizationService = inject(CustomizationService)

  suites?: SuiteDefinitionRow[]
  customization?: Customization
  leadHtml?: string

  async ngOnInit() {
    this.customization = await this.customizationService.getCustomization()
    this.suites = (await this.apiService.get('/definitions/suites')).body
    this.leadHtml = this.customization.content.home.lead
  }
}
