import { CommonModule, DecimalPipe } from '@angular/common'
import { Component, Input } from '@angular/core'
import { ActivatedRoute, Router } from '@angular/router'
import { SubmissionPreview } from '@common/interfaces'

@Component({
  selector: 'app-leaderboard',
  imports: [CommonModule, DecimalPipe],
  templateUrl: './leaderboard.component.html',
  styleUrl: './leaderboard.component.scss',
})
export class LeaderboardComponent {
  @Input() submissions: SubmissionPreview[] = []
  @Input() navigates = false

  constructor(
    private router: Router,
    private route: ActivatedRoute,
  ) {}

  click(submission: SubmissionPreview) {
    if (this.navigates) {
      this.router.navigate(['submissions', submission.uuid], { relativeTo: this.route })
    }
  }
}
