from django.urls import path
from . import views

urlpatterns = [
    path('prompts/', views.prompt_list),        # GET + POST
    path('prompts/<uuid:id>/', views.prompt_detail),
]