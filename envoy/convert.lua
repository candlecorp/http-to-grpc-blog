local json = require("lua.json")

function envoy_on_response(response_handle)
    -- get the body
    local body = response_handle:body(true)
    local body_size = body:length()
    local body_bytes = body:getBytes(0, body_size)
    local raw_json_text = tostring(body_bytes)
    local response_json = json.decode(raw_json_text)

    local out_body = [[
# HELP wasmflow_requests_total Total number of requests to wasmflow components.
# TYPE wasmflow_requests_total counter
# HELP wasmflow_requests_errors_total Total number of errors produced by wasmflow components.
# TYPE wasmflow_requests_errors_total counter
# HELP wasmflow_requests_time_total Total time for executing wasmflow components.
# TYPE wasmflow_requests_time_total counter

]]

    for _, component in ipairs(response_json["stats"]) do
        local requests_total = component["runs"]
        local time_total = component['execution_statistics']['total']
        local error_total = component["errors"]
        local name = component["name"]

        local metrics = string.format([[
wasmflow_requests_total{component="%s"} %s
wasmflow_requests_errors_total{component="%s"} %s
wasmflow_requests_time_total{component="%s"} %s
]],
            name, 
            requests_total, 
            name, 
            error_total, 
            name, 
            time_total)
        out_body = out_body .. metrics
    end

    -- set response body and update content length and content type
    local content_length = response_handle:body(true):setBytes(out_body)
    response_handle:headers():replace("content-length", content_length)
    response_handle:headers():replace("content-type", "text/plain")

end