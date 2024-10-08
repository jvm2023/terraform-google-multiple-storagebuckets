

resource "google_storage_bucket" "buckets" {
  for_each = var.buckets

  name          = each.key
  location      = each.value.location
  storage_class = each.value.storage_class

  uniform_bucket_level_access = each.value.uniform_bucket_level_access
  force_destroy               = each.value.force_destroy

  versioning {
    enabled = each.value.versioning.enabled
  }

  logging {
    log_bucket        = each.value.logging.log_bucket
    log_object_prefix = each.value.logging.log_object_prefix
  }

  dynamic "lifecycle_rule" {
    for_each = each.value.lifecycle_rule
    content {
      action {
        type = lifecycle_rule.value.action.type
      }
      condition {
        age                   = lifecycle_rule.value.condition.age
        created_before        = lifecycle_rule.value.condition.created_before
        with_state            = lifecycle_rule.value.condition.with_state
        matches_storage_class = lifecycle_rule.value.condition.matches_storage_class
        num_newer_versions    = lifecycle_rule.value.condition.num_newer_versions
      }
    }
  }
}







