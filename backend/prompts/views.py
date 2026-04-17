import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from .models import Prompt


@csrf_exempt
@require_http_methods(["GET", "POST"])
def prompt_list(request):
    if request.method == "GET":
        prompts = Prompt.objects.all().values("id", "title", "complexity")
        return JsonResponse(list(prompts), safe=False)

    elif request.method == "POST":
        try:
            data = json.loads(request.body)

            title = data.get("title", "").strip()
            content = data.get("content", "").strip()
            complexity = int(data.get("complexity", 1))

            if len(title) < 3:
                return JsonResponse({"error": "Title too short"}, status=400)

            if len(content) < 20:
                return JsonResponse({"error": "Content too short"}, status=400)

            if complexity < 1 or complexity > 10:
                return JsonResponse({"error": "Invalid complexity"}, status=400)

            prompt = Prompt.objects.create(
                title=title,
                content=content,
                complexity=complexity
            )

            return JsonResponse({"id": str(prompt.id)}, status=201)

        except Exception as e:
            return JsonResponse({"error": str(e)}, status=500)

    return JsonResponse({"error": "Method not allowed"}, status=405)


@csrf_exempt
@require_http_methods(["GET"])
def prompt_detail(request, id):
    """Retrieve a single prompt by ID"""
    try:
        prompt = Prompt.objects.get(id=id)
        data = {
            "id": str(prompt.id),
            "title": prompt.title,
            "content": prompt.content,
            "complexity": prompt.complexity,
            "created_at": prompt.created_at.isoformat()
        }
        return JsonResponse(data)
    except Prompt.DoesNotExist:
        return JsonResponse({"error": "Prompt not found"}, status=404)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)