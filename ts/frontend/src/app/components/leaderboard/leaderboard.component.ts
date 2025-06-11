import { CommonModule, DecimalPipe } from '@angular/common'
import { Component, Input, inject } from '@angular/core'
import { ActivatedRoute, Router } from '@angular/router'
import { SubmissionPreview } from '@common/interfaces'

@Component({
  selector: 'app-leaderboard',
  imports: [CommonModule, DecimalPipe],
  templateUrl: './leaderboard.component.html',
  styleUrl: './leaderboard.component.scss',
})
export class LeaderboardComponent {
  private router = inject(Router)
  private route = inject(ActivatedRoute)

  @Input() submissions: SubmissionPreview[] = []
  @Input() navigates = false

  click(submission: SubmissionPreview) {
    if (this.navigates) {
      this.router.navigate(['submissions', submission.uuid], { relativeTo: this.route })
    }
  }
}
