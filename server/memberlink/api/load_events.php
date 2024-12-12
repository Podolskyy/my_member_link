<?php
include_once("dbconnect.php");

// Disable error display to prevent unexpected output in JSON
error_reporting(0);
ini_set('display_errors', 0);

// Variables for pagination
$results_per_page = 20;
$pageno = isset($_GET['pageno']) ? filter_var($_GET['pageno'], FILTER_VALIDATE_INT, ['options' => ['default' => 1, 'min_range' => 1]]) : 1;
$page_first_result = ($pageno - 1) * $results_per_page;

try {
    // Count total results
    $sqlloadevents_count = "SELECT COUNT(*) as total FROM `tbl_events`";
    $result_count = $conn->query($sqlloadevents_count);
    if (!$result_count) {
        throw new Exception("Failed to count events: " . $conn->error);
    }
    $row_count = $result_count->fetch_assoc();
    $number_of_result = $row_count['total'];
    $number_of_page = ceil($number_of_result / $results_per_page);

    // Fetch paginated results
    $sqlloadevents = "SELECT * FROM `tbl_events` ORDER BY `event_date` DESC LIMIT ?, ?";
    $stmt = $conn->prepare($sqlloadevents);
    if (!$stmt) {
        throw new Exception("Failed to prepare statement: " . $conn->error);
    }
    $stmt->bind_param("ii", $page_first_result, $results_per_page);
    $stmt->execute();
    $result = $stmt->get_result();

    // Prepare response
    if ($result->num_rows > 0) {
        $eventsarray['events'] = array();
        while ($row = $result->fetch_assoc()) {
            $event = [
                'event_id' => $row['event_id'],
                'event_title' => $row['event_title'],
                'event_description' => $row['event_description'],
                'event_startdate' => $row['event_startdate'],
                'event_enddate' => $row['event_enddate'],
                'event_type' => $row['event_type'],
                'event_location' => $row['event_location'],
                'event_filename' => $row['event_filename'],
                'event_date' => $row['event_date']
            ];
            array_push($eventsarray['events'], $event);
        }
        $response = [
            'status' => 'success',
            'data' => $eventsarray,
            'numofpage' => $number_of_page,
            'numberofresult' => $number_of_result
        ];
    } else {
        $response = [
            'status' => 'failed',
            'data' => null,
            'numofpage' => $number_of_page,
            'numberofresult' => $number_of_result
        ];
    }
} catch (Exception $e) {
    $response = [
        'status' => 'error',
        'message' => $e->getMessage()
    ];
}

// Send JSON response
header('Content-Type: application/json');
echo json_encode($response);
?>
