import { Component, Input } from '@angular/core'

@Component({
  selector: 'app-site-heading',
  imports: [],
  templateUrl: './site-heading.component.html',
  styleUrl: './site-heading.component.scss',
})
export class SiteHeadingComponent {
  @Input() title?: string
  @Input() logo?: string
}
