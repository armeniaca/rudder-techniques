####################################################################################
# Copyright 2014 Normation SAS
#####################################################################################
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, Version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#####################################################################################

bundle agent metrics_reporting
{
  classes:
    "accept_metrics" expression => strcmp("&SEND_METRICS&", "yes");
    "run_metrics" expression => "accept_metrics.role_rudder_server_root";

    "pass2" expression => "pass1";
    "pass1" expression => "any";

  methods:
    run_metrics.pass2.metrics_ok::
      "any" usebundle => rudder_common_report("server-roles", "result_success", "&TRACKINGKEY&", "Send metrics to rudder-project", "None", "Sending metrics to rudder-project succeeded");
    run_metrics.pass2.metrics_error::
      "any" usebundle => rudder_common_report("server-roles", "result_error", "&TRACKINGKEY&", "Send metrics to rudder-project", "None", "Sending metrics to rudder-project failed");
    !run_metrics::
      "any" usebundle => rudder_common_report("server-roles", "result_na", "&TRACKINGKEY&", "Send metrics to rudder-project", "None", "Sending metrics to rudder-project is not enabled. Skipping.");

  commands:
    run_metrics.!(metrics_ok|metrics_error)::
      "/opt/rudder/bin/rudder-metrics-reporting -s"
        # 10080 mn is 7 days
        classes => rudder_common_classes_persist("metrics" ,"10080");
}
