module "autoscaling_twilreapi_worker" {
  source            = "../modules/autoscaling"
  env_identifier    = "${local.twilreapi_identifier}-worker"
  autoscaling_group = "${element(module.twilreapi_eb_app_env.worker_autoscaling_groups, 0)}"
  queue_url         = "${module.twilreapi_eb_app_env.worker_queue_url}"
}

module "autoscaling_scfm_worker" {
  source            = "../modules/autoscaling"
  env_identifier    = "${local.scfm_identifier}-worker"
  autoscaling_group = "${element(module.scfm_eb_app_env.worker_autoscaling_groups, 0)}"
  queue_url         = "${module.scfm_eb_app_env.worker_queue_url}"
}
