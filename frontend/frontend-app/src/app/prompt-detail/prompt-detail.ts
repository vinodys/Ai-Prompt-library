import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router } from '@angular/router';
import { PromptService } from '../services/prompt.service';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-prompt-detail',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './prompt-detail.html'
})
export class PromptDetailComponent implements OnInit {

  prompt: any;

  constructor(
    private route: ActivatedRoute,
    private service: PromptService,
    private router: Router   // ✅ add this
  ) {}

  ngOnInit(): void {
  const id = this.route.snapshot.paramMap.get('id');

  if (id) {
    this.service.getPrompt(id).subscribe({
      next: (data) => {
        console.log('DETAIL:', data);
        this.prompt = data;
      },
      error: (err) => {
        console.error(err);
      }
    });
  }
}

  // ✅ ADD HERE (inside class, below ngOnInit)
  goBack() {
    this.router.navigateByUrl('/', { replaceUrl: true });
  }
}