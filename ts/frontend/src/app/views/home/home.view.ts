import { Component } from '@angular/core'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'

@Component({
  // eslint-disable-next-line @angular-eslint/component-selector
  selector: 'view-home',
  imports: [ContentComponent, SectionComponent],
  templateUrl: './home.view.html',
  styleUrl: './home.view.scss',
})
// eslint-disable-next-line @angular-eslint/component-class-suffix
export class HomeView {}
