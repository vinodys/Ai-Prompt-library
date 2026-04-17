import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { PromptService } from '../services/prompt.service';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-prompt-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './prompt-list.html'
})
export class PromptListComponent {

  prompts$: Observable<any[]>;

  constructor(private service: PromptService) {
    this.prompts$ = this.service.getPrompts(); // 🔥 reactive
  }
}