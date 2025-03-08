//
//  ToastsView.swift
//  CommonUI
//
//  Created by 공태웅 on 3/8/25.
//

import SwiftUI

struct ToastsView: View {
    
    // MARK: Properties
    
    @Binding var toasts: [Toast]
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let safeArea = geometry.safeAreaInsets
            
            ZStack {
                VStack(spacing: 10) {
                    ForEach(toasts, id: \.id) { toast in
                        ToastView(toast: toast)
                            .task {
                                try? await Task.sleep(for: toast.duration)
                                dismissToast(id: toast.id)
                            }
                            .gesture(
                                DragGesture()
                                    .onEnded { dragGestureEnded(at: toast.id, value: $0) }
                            )
                            .frame(maxWidth: size.width * 0.8)
                    }
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity.animation(.easeInOut(duration: 1.0))))
                }
                .animation(.easeInOut, value: toasts)
            }
            .padding(.bottom, safeArea.bottom == .zero ? 20 : 15)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
    
}


private extension ToastsView {
    func dragGestureEnded(at id: String, value: DragGesture.Value) {
        guard value.translation.height > 20 || value.velocity.height > 100 else { return }
        dismissToast(id: id)
    }
    
    func dismissToast(id: String) {
        toasts.removeAll(where: { $0.id == id })
    }
}

private struct ToastView: View {
    
    // MARK: Properties
    
    var toast: Toast
    
    var body: some View {
        Text(toast.message)
            .foregroundStyle(.black)
            .font(.callout)
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
            )
    }
}
