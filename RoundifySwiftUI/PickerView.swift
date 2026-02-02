//
//  PickerView.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 23/12/25.
//

import SwiftUI

// MARK: - Enhanced Reusable Component with Full Styling Options
struct StyledSegmentedPicker<T: Hashable>: View {
    let items: [T]
    let itemLabel: (T) -> String
    @Binding var selection: T
    var backgroundColor: Color = Color(.systemGray6)
    var foregroundColor: Color = .blue
    var selectedTextColor: Color = .white
    var unselectedTextColor: Color = .primary
    var padding: CGFloat = 16
    var onSelectionChange: ((T) -> Void)?
    
    var body: some View {
        Picker("", selection: $selection) {
            ForEach(items, id: \.self) { item in
                Text(itemLabel(item)).tag(item)
            }
        }
        .pickerStyle(.segmented)
        .background(backgroundColor)
        .cornerRadius(8)
        .padding(.horizontal, padding)
        .onChange(of: selection) { oldValue, newValue in
            onSelectionChange?(newValue)
        }
        // Apply tint color for selected segment
        .tint(foregroundColor)
    }
}

// MARK: - Custom Segment Control (No Gaps, Full Control)
struct CustomSegmentControl<T: Hashable>: View {
    let items: [T]
    let itemLabel: (T) -> String
    @Binding var selection: T
    var backgroundColor: Color = Color.gray.opacity(0.2)
    var selectedBackgroundColor: Color = .blue
    var selectedTextColor: Color = .white
    var unselectedTextColor: Color = .primary
    var cornerRadius: CGFloat = 20
    var padding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    var onSelectionChange: ((T) -> Void)?
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.self) { item in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = item
                        onSelectionChange?(item)
                    }
                }) {
                    Text(itemLabel(item))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selection == item ? selectedTextColor : unselectedTextColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            selection == item ? selectedBackgroundColor : Color.clear
                        )
                        .cornerRadius(cornerRadius - 2)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(padding)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
    }
}


// MARK: - Custom Segment Control (No Gaps, Full Control)
struct CustomSegmentControlwithHW<T: Hashable>: View {
    let items: [T]
    let itemLabel: (T) -> String
    @Binding var selection: T
    var backgroundColor: Color = Color.gray.opacity(0.2)
    var selectedBackgroundColor: Color = .blue
    var selectedTextColor: Color = .white
    var unselectedTextColor: Color = .primary
    var cornerRadius: CGFloat = 20
    var padding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var segmentHeight: CGFloat = 36
    var onSelectionChange: ((T) -> Void)?
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.self) { item in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = item
                        onSelectionChange?(item)
                    }
                }) {
                    Text(itemLabel(item))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(selection == item ? selectedTextColor : unselectedTextColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: segmentHeight)
                        .background(
                            selection == item ? selectedBackgroundColor : Color.clear
                        )
                        .cornerRadius(cornerRadius - 2)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(padding)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .frame(width: width, height: height)
    }
}
