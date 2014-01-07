<%
    ui.decorateWith("appui", "standardEmrPage")
    ui.includeJavascript("uicommons", "moment.min.js")
    ui.includeJavascript("uicommons", "angular.min.js")
    ui.includeJavascript("mirebalaisreports", "ui-bootstrap-tpls-0.6.0.min.js")
    ui.includeJavascript("reportingui", "adHocHome.js")
    ui.includeCss("reportingui", "runReport.css")
%>

<%= ui.includeFragment("appui", "messages", [ codes: [
        "reportingui.adHocReport.timeframe.startDateLabel",
        "reportingui.adHocReport.timeframe.endDateLabel"
].flatten()
]) %>

<script type="text/javascript">
    var adHocExports = ${ ui.toJson(exports) };

    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.escapeJs(ui.message("reportingui.reportsapp.home.title")) }", link: emr.pageLink("reportingui", "reportsapp/home") },
        { label: "${ ui.escapeJs(ui.message("reportingui.adHocAnalysis.label")) }", link: "${ ui.escapeJs(ui.thisUrl()) }" }
    ];
</script>

<h1>Ad Hoc Exports</h1>

<div id="design-ad-hoc">
    <h3>Design your exports</h3>

    <fieldset>
        <legend>
            <i class="icon-user"></i>
            Patient
        </legend>

        <ul>
            <li>
                <a class="button" href="${ui.pageLink("reportingui", "adHocAnalysis", [ definitionClass: "org.openmrs.module.reporting.dataset.definition.PatientDataSetDefinition" ]) }">New</a>
            </li>

            <% exports.findAll { it.type == "PatientDataSetDefinition" } .each { %>
                <li>
                    <a href="adHocAnalysis.page?definition=${ it.uuid }">
                        ${ it.name }
                        <em>${ it.description }</em>
                    </a>
                </li>
            <% } %>

        </ul>
    </fieldset>
</div>

<div id="run-ad-hoc" ng-app="runAdHocExport" ng-controller="RunAdHocExportController">
    <h3>Run an export</h3>

    <span ng-hide="exports">
        Create some exports first
    </span>

    <div ng-show="exports">
        <ul>
            <li ng-repeat="export in exports">
                <input type="checkbox" name="dataset" ng-model="export.selected" id="export-{{\$index}}"/>
                <label for="export-{{\$index}}">
                    {{ export.name }} <em>{{ export.description }}</em>
                </label>
            </li>
        </ul>

        <ul>
            <li ng-repeat="param in requiredParameters()">
                {{ param.label | translate }}:
                <span ng-include="'paramWidget/' + param.type + '.page'"/>
            </li>
        </ul>

        <button ng-click="run()" ng-disabled="!canRun()">
            Run
        </button>
    </div>
</div>