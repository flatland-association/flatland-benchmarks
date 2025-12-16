import { CommonModule } from '@angular/common'
import { Component, Input } from '@angular/core'
import { PageContents } from '@common/interfaces'
import { PublicResourcePipe } from '../../pipes/public-resource/public-resource.pipe'

@Component({
  selector: 'app-site-heading',
  imports: [PublicResourcePipe, CommonModule],
  templateUrl: './site-heading.component.html',
  styleUrl: './site-heading.component.scss',
})
export class SiteHeadingComponent {
  @Input() title?: string
  @Input() logo?: string
  /** header image to display. If not provided, `logo` is used instead. */
  @Input() headerImage?: PageContents['headerImage']

  HEADERIMAGE_SIZES = {
    LOGO: 'max-w-40 max-h-24 -my-2',
    FULL: 'w-full',
  }
}
