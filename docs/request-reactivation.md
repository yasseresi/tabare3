# Request Reactivation Endpoint — API Spec (mobile client)

Purpose
- Allow a recipient to reactivate (re-open) a previously cancelled blood request from the mobile client.

Suggested endpoint
- Method: POST
- Path: /api/v1/requests/{id}/reactivate/

Behavior and rules
1. Authorization
   - Requester must be authenticated and must own the request (recipient who created it).
   - Return 403 if not owner or not authenticated.

2. Idempotency & state handling
   - If request is currently `cancelled`, transition it to `active` and return the full request resource.
   - If request is already `active`, return 200 with the current resource (no-op).
   - If request is `completed`/`fulfilled`/`expired`, return 400 with an explanatory error (reactivation not allowed).

3. Input
   - No request body required (POST with path param). If needed, accept optional `note` or `reopen_reason`.

4. Response
   - 200 OK with the updated request resource (same shape as GET /requests/{id}/). The client maps fields the same way it already does for list/detail responses.
   - 400 Bad Request when reactivation is not allowed (include error code/message).
   - 403 Forbidden when caller lacks permission.
   - 404 Not Found when request id does not exist.

5. Side effects
   - Preserve an audit trail: add `reactivated_at` and `reactivated_by` fields rather than deleting cancellation history, or keep cancellation metadata while adding reactivation metadata.
   - Optionally trigger notifications to donors/watchers that the request is active again.

6. Validation & business rules
   - Optionally restrict reactivation to a configurable time window (e.g., within 7 days of cancellation).
   - If request's deadline has passed, either disallow reactivation or accept an optional new deadline parameter in the request body.

7. Tests (recommended)
   - Happy path: cancelled -> active, returns 200 and updated resource.
   - Idempotent path: active -> active (200, no change).
   - Forbidden: different user attempts reactivation -> 403.
   - Not allowed: completed/expired -> 400.
   - Not found -> 404.

8. OpenAPI / Schema
- Add the path to docs/blood_api_schema.yaml and update the requests resource schema if new audit fields are introduced (reactivated_at, reactivated_by).

9. Django REST Framework example (implementation sketch)
- Add a ViewSet action on the RequestViewSet:

```python
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework import status
from django.utils import timezone

class RequestViewSet(ModelViewSet):
    queryset = Request.objects.all()
    serializer_class = RequestSerializer

    @action(detail=True, methods=['post'], url_path='reactivate')
    def reactivate(self, request, pk=None):
        obj = self.get_object()
        if not request.user == obj.recipient:
            return Response({'detail': 'Forbidden'}, status=status.HTTP_403_FORBIDDEN)
        if obj.status == 'active':
            return Response(self.get_serializer(obj).data)
        if obj.status in ['completed', 'expired']:
            return Response({'detail': 'Cannot reactivate a completed or expired request'}, status=status.HTTP_400_BAD_REQUEST)
        obj.status = 'active'
        obj.reactivated_at = timezone.now()
        obj.reactivated_by = request.user
        # preserve cancellation_reason for audit, or clear if policy prefers
        obj.save()
        return Response(self.get_serializer(obj).data)
```

10. Migration
- If adding new fields (reactivated_at/reactivated_by), include a migration and update serializers.

11. Backwards compatibility
- Keep existing cancel endpoint (/requests/{id}/cancel/) unchanged.
- Document the new endpoint in API changelog and notify the mobile team to remove client-side fallbacks once backend is deployed.

---

Owner & next steps
- Owner: backend team
- Add to backend backlog, implement endpoint, add tests, update OpenAPI, and notify mobile team when deployed.
