import { Component } from '@angular/core'
import { RouterOutlet } from '@angular/router'
import { ApiService } from './features/api/api.service'

@Component({
  selector: 'app-root',
  imports: [RouterOutlet],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss',
})
export class AppComponent {
  // this is to prevent tree-shaking ApiService
  constructor(private _apiService: ApiService) {}
}
