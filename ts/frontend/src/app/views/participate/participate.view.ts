import { Component } from '@angular/core'
import { FormsModule } from '@angular/forms'
import { ContentComponent } from '@flatland-association/flatland-ui'
import { ApiService } from '../../features/api/api.service'

@Component({
  selector: 'view-participate',
  imports: [FormsModule, ContentComponent],
  templateUrl: './participate.view.html',
  styleUrl: './participate.view.scss',
})
export class ParticipateView {
  submissionImageUrl = ''
  submissionResult?: string

  constructor(public apiService: ApiService) {}

  async submit() {
    const response = await this.apiService.post('/submissions', {
      body: { submission_image: this.submissionImageUrl },
    })
    if (response.body?.id) {
      const id = response.body.id
      console.log(id)
      const interval = window.setInterval(() => {
        this.apiService.get('/submissions/:id', { params: { id: `${id}` } }).then((res) => {
          if (res.body) {
            this.submissionResult = JSON.stringify(res.body)
            window.clearInterval(interval)
          }
          console.log(res)
        })
      }, 1000)
    }
  }
}
