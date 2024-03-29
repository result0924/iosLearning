import UIKit
@preconcurrency import CorePlot

class PieChartController : UIViewController, CPTPieChartDataSource, CPTPieChartDelegate {
    private let pieGraph = CPTXYGraph(frame: .zero)

    private let dataForChart = [20.0, 30.0, 60.0]

    // MARK: - Initialization

    override func viewDidAppear(_ animated : Bool)
    {
        super.viewDidAppear(animated)

        // Create graph from theme
        let newGraph = self.pieGraph
        newGraph.apply(CPTTheme(named: .darkGradientTheme))

        let hostingView = self.view as! CPTGraphHostingView
        hostingView.hostedGraph = newGraph

        // Paddings
        newGraph.paddingLeft   = 20.0
        newGraph.paddingRight  = 20.0
        newGraph.paddingTop    = 20.0
        newGraph.paddingBottom = 20.0

        newGraph.axisSet = nil

        let whiteText = CPTMutableTextStyle()
        whiteText.color = .white()

        newGraph.titleTextStyle = whiteText
        newGraph.title          = "Graph Title"

        // Add pie chart
        let piePlot = CPTPieChart(frame: .zero)
        piePlot.dataSource      = self
        piePlot.pieRadius       = 131.0
        piePlot.identifier      = "Pie Chart 1" as NSString
        piePlot.startAngle      = CGFloat(.pi / 4.0)
        piePlot.sliceDirection  = .counterClockwise
        piePlot.centerAnchor    = CGPoint(x: 0.5, y: 0.38)
        piePlot.borderLineStyle = CPTLineStyle()
        piePlot.delegate        = self
        newGraph.add(piePlot)
    }

    // MARK: - Plot Data Source Methods

    nonisolated func numberOfRecords(for plot: CPTPlot) -> UInt
    {
        return UInt(self.dataForChart.count)
    }

    nonisolated func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any?
    {
        if Int(record) > self.dataForChart.count {
            return nil
        }
        else {
            switch CPTPieChartField(rawValue: Int(field))! {
            case .sliceWidth:
                return (self.dataForChart)[Int(record)] as NSNumber

            default:
                return record as NSNumber
            }
        }
    }

    nonisolated func dataLabel(for plot: CPTPlot, record: UInt) -> CPTLayer?
    {
        let label = CPTTextLayer(text:"\(record)")

        if let textStyle = label.textStyle?.mutableCopy() as? CPTMutableTextStyle {
            textStyle.color = .lightGray()

            label.textStyle = textStyle
        }

        return label
    }

    nonisolated func radialOffset(for piePlot: CPTPieChart, record recordIndex: UInt) -> CGFloat
    {
        var offset: CGFloat = 0.0

        if ( recordIndex == 0 ) {
            offset = piePlot.pieRadius / 8.0
        }

        return offset
    }

    // MARK: - Delegate Methods

    nonisolated func pieChart(_ plot: CPTPieChart, sliceWasSelectedAtRecord idx: UInt) {
        self.pieGraph.title = "Selected index: \(idx)"
    }
}
