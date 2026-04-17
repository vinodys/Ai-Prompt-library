import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class PromptService {

  // 🔥 auto-detect environment
  private api =
    window.location.hostname === 'localhost'
      ? 'http://localhost:8000/api/prompts/'     // local dev
      : 'http://backend:8000/api/prompts/';      // docker

  constructor(private http: HttpClient) {}

  getPrompts(): Observable<any[]> {
    return this.http.get<any[]>(this.api);
  }

  getPrompt(id: string): Observable<any> {
    return this.http.get<any>(`${this.api}${id}/`);
  }

  createPrompt(data: any) {
  return this.http.post(this.api, data);
}
}