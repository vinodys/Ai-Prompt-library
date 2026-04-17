import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators, FormGroup } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { PromptService } from '../services/prompt.service';

@Component({
  selector: 'app-add-prompt',
  standalone: true,
  imports: [CommonModule, RouterModule, ReactiveFormsModule],
  templateUrl: './add-prompt.html'
})

export class AddPromptComponent {

  form: FormGroup;

  constructor(
    private fb: FormBuilder,
    private service: PromptService,
    private router: Router
  ) {
    this.form = this.fb.group({
      title: ['', [Validators.required, Validators.minLength(3)]],
      content: ['', [Validators.required, Validators.minLength(20)]],
      complexity: [1, [Validators.required, Validators.min(1), Validators.max(10)]]
    });
  }

  submit() {
    console.log("FORM DATA:", this.form.value); // debug

    if (this.form.invalid) return;

    this.service.createPrompt(this.form.value).subscribe({
      next: () => {
        alert("Prompt Created!");
        this.router.navigateByUrl('/');
      },
      error: (err) => {
        console.error("ERROR:", err);
      }
    });
  }
}