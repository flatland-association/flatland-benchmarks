import { Component } from '@angular/core'
import { ContentComponent, SectionComponent } from '@flatland-association/flatland-ui'
import { FaIconComponent } from '@fortawesome/angular-fontawesome'
import { faPlus } from '@fortawesome/free-solid-svg-icons'

@Component({
  selector: 'view-home',
  imports: [ContentComponent, SectionComponent, FaIconComponent],
  templateUrl: './home.view.html',
  styleUrl: './home.view.scss',
})
export class HomeView {
  faPlus = faPlus
}
