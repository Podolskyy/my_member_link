<?php
include_once("dbconnect.php");

// Disable error display to prevent unexpected output in JSON
error_reporting(0);
ini_set('display_errors', 0);

// Variables for pagination
$results_per_page = 2;
$pageno = isset($_GET['pageno']) ? filter_var($_GET['pageno'], FILTER_VALIDATE_INT, ['options' => ['default' => 1, 'min_range' => 1]]) : 1;
$page_first_result = ($pageno - 1) * $results_per_page;

try {
    // Count total results
    $sqlcount = "SELECT COUNT(*) as total FROM `tbl_products`";
    $result_count = $conn->query($sqlcount);
    if (!$result_count) {
        throw new Exception("Failed to count products: " . $conn->error);
    }
    $row_count = $result_count->fetch_assoc();
    $number_of_result = $row_count['total'];
    $number_of_page = ceil($number_of_result / $results_per_page);

    // Fetch paginated results
    $sqlfetch = "SELECT * FROM `tbl_products` ORDER BY `product_id` ASC LIMIT ?, ?";
    $stmt = $conn->prepare($sqlfetch);
    if (!$stmt) {
        throw new Exception("Failed to prepare statement: " . $conn->error);
    }
    $stmt->bind_param("ii", $page_first_result, $results_per_page);
    $stmt->execute();
    $result = $stmt->get_result();

    // Prepare response
    if ($result->num_rows > 0) {
        $productsarray['products'] = array();
        while ($row = $result->fetch_assoc()) {
            $product = [
                'product_id' => (string)$row['product_id'],
                'product_name' => (string)$row['product_name'],
                'product_picture' => (string)$row['product_picture'],
                'product_description' => (string)$row['product_description'],
                'product_quantity' => (string)$row['product_quantity'],
                'product_price' => (string)$row['product_price']
            ];
            array_push($productsarray['products'], $product);
        }
        $response = [
            'status' => 'success',
            'data' => $productsarray,
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
