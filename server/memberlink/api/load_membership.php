<?php
include_once("dbconnect.php");

// Disable error display to prevent unexpected output in JSON
error_reporting(0);
ini_set('display_errors', 0);

try {
    // Fetch all membership data
    $sqlfetch = "SELECT * FROM `tbl_membership` ORDER BY `membership_id` ASC";
    $result = $conn->query($sqlfetch);

    // Prepare response
    if ($result->num_rows > 0) {
        $membershipsarray['memberships'] = array();
        while ($row = $result->fetch_assoc()) {
            $membership = [
                'membership_id' => (string)$row['membership_id'],
                'membership_name' => (string)$row['membership_name'],
                'membership_picture' => (string)$row['membership_picture'],
                'membership_description' => (string)$row['membership_description'],
                'membership_price' => (string)$row['membership_price']
            ];
            array_push($membershipsarray['memberships'], $membership);
        }
        $response = [
            'status' => 'success',
            'data' => $membershipsarray
        ];
    } else {
        $response = [
            'status' => 'failed',
            'data' => null
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
