//
//  StepperTabs.swift
//  StepperTabs
//
//  Created by Sebastián García Burgos on 20/5/22.
//

import SwiftUI

@available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *)
struct StepperTabsView: View {
    
    @Binding var stepperData: StepperData
    var isUserInputEnabled: Bool
    var allowInputUntil: Int = Int.max
    var selectedTabBackgroundColor: Color
    var notSelectedTabBackgroundColor: Color
    var isProcedural: Bool
    
    //DEFAULT INIT
    init(
        stepperData: Binding<StepperData>,
        isUserInputEnabled: Bool,
        selectedTabBackgroundColor: Color = .accentColor,
        notSelectedTabBackgroundColor: Color = .secondary,
        isProcedural: Bool = true
        
    ){
        self._stepperData = stepperData
        self.isUserInputEnabled = isUserInputEnabled
        self.selectedTabBackgroundColor = selectedTabBackgroundColor
        self.notSelectedTabBackgroundColor = notSelectedTabBackgroundColor
        self.isProcedural = isProcedural
    }
    
    //UNTIL INIT
    init(
        stepperData: Binding<StepperData>,
        selectedTabBackgroundColor: Color = .accentColor,
        notSelectedTabBackgroundColor: Color = .secondary,
        allowInputUntil: Int,
        isProcedural: Bool = true
        
    ){
        self._stepperData = stepperData
        self.isUserInputEnabled = true
        self.selectedTabBackgroundColor = selectedTabBackgroundColor
        self.notSelectedTabBackgroundColor = notSelectedTabBackgroundColor
        self.isProcedural = isProcedural
        self.allowInputUntil = allowInputUntil
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            ScrollViewReader{ proxy in
                HStack{
                    ForEach(0..<stepperData.steps.count, id: \.self){ i in
                        if let step = stepperData.steps[i] {
                            Text(isProcedural ? "\(i + 1). \(step)" : step)
                                .bold()
                                .lineLimit(1)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .foregroundColorFor(
                                    position: i,
                                    in: stepperData.selectedStep,
                                    isProcedural: isProcedural
                                )
                                .background(getBackgroundColor(position: i))
                                .cornerRadius(15)
                                .onTapGesture {
                                    if isUserInputEnabled && i < allowInputUntil && stepperData.selectedStep <= allowInputUntil {
                                        withAnimation {
                                            stepperData.selectedStep = i
                                        }
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal)
                .onChange(of: stepperData.selectedStep) { newSelectedIndex in
                    withAnimation {
                        proxy.scrollTo(newSelectedIndex, anchor: .center)
                    }
                }
            }
        }
        .padding(.vertical)
        //.frame(height: 100, alignment: .center)
    }
    
    private func getBackgroundColor(position: Int) -> Color{
        if position < stepperData.selectedStep && isProcedural {
            // Position is lower than selected one.
            return selectedTabBackgroundColor.opacity(0.5)
        }
        else if position == stepperData.selectedStep {
            // Position is the selected one.
            return selectedTabBackgroundColor
        }
        else{
            // Position is major than selected one
            return Color(UIColor.systemBackground)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *)
struct StepperData{
    let steps: [String]
    var selectedStep: Int = 0{
        /**
         Prevent selectedStep from being out of range
         */
        didSet{
            if selectedStep < 0 {
                selectedStep = 0
            }
            else if selectedStep > (steps.count - 1){
                selectedStep = (steps.count - 1)
            }
        }
    }
    
    mutating func nextStep(){
        if selectedStep != steps.count - 1 {
            selectedStep += 1
        }
        else {
            selectedStep = 0
        }
    }
    
    mutating func previousStep(){
        if selectedStep != 0 {
            selectedStep -= 1
        }
        else {
            selectedStep = steps.count - 1
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15, watchOS 6.0, *)
private extension View{
    
    /**
     Apply the corresponding foreground color for a tab in a StepperTab
     */
    @ViewBuilder func foregroundColorFor(position: Int, in selectedPosition: Int, isProcedural: Bool) -> some View {
        if isProcedural {
            if position > selectedPosition {
                // Position is mejor than selected one.
                self
                    .foregroundColor(Color(UIColor.systemGray))
            }
            else{
                // Position is lower than selected one.
                self
            }
        }
        else{
            if position == selectedPosition {
                // Position is the selected one.
                self
            }
            else {
                // Position is not the selected one.
                self
                    .foregroundColor(Color(UIColor.systemGray))
            }
        }
    }
}

/*
struct StepperTabs_Previews: PreviewProvider {
    static var previews: some View {
        StepperTabs()
    }
}
 */
