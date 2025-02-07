import { DecimalPipe } from '@angular/common'
import { Component, Input } from '@angular/core'
import { SubmissionPreview } from '@common/interfaces.mjs'

@Component({
  selector: 'app-leaderboard',
  imports: [DecimalPipe],
  templateUrl: './leaderboard.component.html',
  styleUrl: './leaderboard.component.scss',
})
export class LeaderboardComponent {
  @Input() submissions: SubmissionPreview[] = []
}
